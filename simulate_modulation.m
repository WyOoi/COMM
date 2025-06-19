function [ber, txSignal] = simulate_modulation(modType, data, SNR_dB)
% SIMULATE_MODULATION Simulates digital modulation and returns BER
%   [ber, txSignal] = simulate_modulation(modType, data, SNR_dB)
%
%   Inputs:
%       modType - Modulation type ('BPSK', 'QPSK', '16QAM')
%       data    - Binary data to transmit
%       SNR_dB  - Signal-to-Noise Ratio in dB
%
%   Outputs:
%       ber     - Bit Error Rate
%       txSignal - Transmitted signal

% Convert SNR from dB to linear scale
SNR = 10^(SNR_dB/10);

switch upper(modType)
    case 'BPSK'
        % BPSK Modulation
        symbols = 2*data - 1; % Convert 0->-1, 1->+1
        txSignal = symbols;
        
        % Add AWGN noise
        rxSignal = awgn(txSignal, SNR_dB, 'measured');
        
        % BPSK Demodulation
        rxData = real(rxSignal) > 0;
        
        % Calculate BER
        [~, ber] = biterr(data, rxData);
        
    case 'QPSK'
        % Reshape data for QPSK (2 bits per symbol)
        if mod(length(data), 2) ~= 0
            data = [data; 0]; % Pad with 0 if odd number of bits
        end
        
        % Group bits into pairs
        dataReshaped = reshape(data, 2, [])';
        
        % QPSK Mapping (Gray coded)
        % 00 -> -1-1i, 01 -> -1+1i, 10 -> 1-1i, 11 -> 1+1i
        mapping = [-1-1i, -1+1i, 1-1i, 1+1i]/sqrt(2); % Normalize energy
        symbols = zeros(size(dataReshaped, 1), 1);
        
        for i = 1:size(dataReshaped, 1)
            symbols(i) = mapping(bin2dec(num2str(dataReshaped(i,:))) + 1);
        end
        
        txSignal = symbols;
        
        % Add AWGN noise
        rxSignal = awgn(txSignal, SNR_dB, 'measured');
        
        % QPSK Demodulation
        rxSymbols = zeros(length(rxSignal), 2);
        
        for i = 1:length(rxSignal)
            % Find closest constellation point
            [~, idx] = min(abs(rxSignal(i) - mapping));
            binVal = dec2bin(idx-1, 2) - '0';
            rxSymbols(i,:) = binVal;
        end
        
        % Reshape back to bits
        rxData = reshape(rxSymbols', [], 1);
        rxData = rxData(1:length(data)); % Trim to original length
        
        % Calculate BER
        [~, ber] = biterr(data, rxData);
        
    case '16QAM'
        % Reshape data for 16-QAM (4 bits per symbol)
        if mod(length(data), 4) ~= 0
            padLength = 4 - mod(length(data), 4);
            data = [data; zeros(padLength, 1)]; % Pad with 0s
        end
        
        % Group bits into groups of 4
        dataReshaped = reshape(data, 4, [])';
        
        % 16-QAM Mapping (Gray coded)
        % Create 16-QAM constellation
        qamModulator = comm.RectangularQAMModulator('ModulationOrder', 16, ...
                                                   'BitInput', true, ...
                                                   'NormalizationMethod', 'Average power');
        
        % Modulate
        txSignal = qamModulator(data);
        
        % Add AWGN noise
        rxSignal = awgn(txSignal, SNR_dB, 'measured');
        
        % Demodulate
        qamDemodulator = comm.RectangularQAMDemodulator('ModulationOrder', 16, ...
                                                       'BitOutput', true, ...
                                                       'NormalizationMethod', 'Average power');
        
        rxData = qamDemodulator(rxSignal);
        rxData = rxData(1:length(data)); % Trim to original length
        
        % Calculate BER
        [~, ber] = biterr(data, rxData);
        
    otherwise
        error('Unsupported modulation type: %s', modType);
end
end 