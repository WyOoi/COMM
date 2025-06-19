%% Digital Modulation Decision-Maker: Satellite Data Uplink for Remote Agricultural Farms
% This script simulates and compares different digital modulation techniques
% for a satellite uplink communication system from remote agricultural farms.
% Techniques compared: BPSK, QPSK, and 16-QAM
% Performance metrics: BER vs SNR, bandwidth efficiency

clear all;
close all;
clc;

%% Simulation Parameters
numBits = 1e6;        % Number of bits to transmit
SNR_dB = 0:2:20;      % SNR range in dB
channelType = 'AWGN'; % Channel model

%% Generate random binary data
data = randi([0 1], numBits, 1);

%% Modulation Techniques Simulation
% Initialize BER results
ber_bpsk = zeros(1, length(SNR_dB));
ber_qpsk = zeros(1, length(SNR_dB));
ber_16qam = zeros(1, length(SNR_dB));

% Run simulation for each SNR value
for i = 1:length(SNR_dB)
    fprintf('Simulating SNR = %d dB\n', SNR_dB(i));
    
    % BPSK Modulation
    [ber_bpsk(i), ~] = simulate_modulation('BPSK', data, SNR_dB(i));
    
    % QPSK Modulation
    [ber_qpsk(i), ~] = simulate_modulation('QPSK', data, SNR_dB(i));
    
    % 16-QAM Modulation
    [ber_16qam(i), ~] = simulate_modulation('16QAM', data, SNR_dB(i));
end

%% Plot BER vs SNR
figure;
semilogy(SNR_dB, ber_bpsk, 'b-o', 'LineWidth', 2);
hold on;
semilogy(SNR_dB, ber_qpsk, 'r-s', 'LineWidth', 2);
semilogy(SNR_dB, ber_16qam, 'g-d', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER Performance Comparison of Digital Modulation Techniques');
legend('BPSK', 'QPSK', '16-QAM', 'Location', 'southwest');
saveas(gcf, 'ber_comparison.png');

%% Bandwidth Efficiency Analysis
% Calculate spectral efficiency (bits/s/Hz)
spectral_efficiency_bpsk = 1;
spectral_efficiency_qpsk = 2;
spectral_efficiency_16qam = 4;

figure;
bar([spectral_efficiency_bpsk, spectral_efficiency_qpsk, spectral_efficiency_16qam]);
set(gca, 'XTickLabel', {'BPSK', 'QPSK', '16-QAM'});
ylabel('Spectral Efficiency (bits/s/Hz)');
title('Bandwidth Efficiency Comparison');
grid on;
saveas(gcf, 'bandwidth_efficiency.png');

%% Power Efficiency Analysis
% Calculate required SNR for BER = 10^-4
target_ber = 1e-4;
required_snr_bpsk = interp1(ber_bpsk, SNR_dB, target_ber, 'linear', 'extrap');
required_snr_qpsk = interp1(ber_qpsk, SNR_dB, target_ber, 'linear', 'extrap');
required_snr_16qam = interp1(ber_16qam, SNR_dB, target_ber, 'linear', 'extrap');

figure;
bar([required_snr_bpsk, required_snr_qpsk, required_snr_16qam]);
set(gca, 'XTickLabel', {'BPSK', 'QPSK', '16-QAM'});
ylabel('Required SNR (dB) for BER = 10^{-4}');
title('Power Efficiency Comparison');
grid on;
saveas(gcf, 'power_efficiency.png');

%% Display Results and Recommendation
fprintf('\n\n===== MODULATION TECHNIQUE COMPARISON RESULTS =====\n');
fprintf('Scenario: Satellite Data Uplink for Remote Agricultural Farms\n\n');

fprintf('BER Performance at SNR = 10 dB:\n');
fprintf('BPSK:  %e\n', ber_bpsk(SNR_dB == 10));
fprintf('QPSK:  %e\n', ber_qpsk(SNR_dB == 10));
fprintf('16QAM: %e\n', ber_16qam(SNR_dB == 10));

fprintf('\nSpectral Efficiency (bits/s/Hz):\n');
fprintf('BPSK:  %.1f\n', spectral_efficiency_bpsk);
fprintf('QPSK:  %.1f\n', spectral_efficiency_qpsk);
fprintf('16QAM: %.1f\n', spectral_efficiency_16qam);

fprintf('\nRequired SNR (dB) for BER = 10^-4:\n');
fprintf('BPSK:  %.2f\n', required_snr_bpsk);
fprintf('QPSK:  %.2f\n', required_snr_qpsk);
fprintf('16QAM: %.2f\n', required_snr_16qam);

fprintf('\n===== RECOMMENDATION =====\n');
% Logic for recommendation will depend on simulation results
% This is a placeholder for the actual recommendation logic
fprintf('Based on the simulation results, the recommended modulation technique\n');
fprintf('will be determined by the specific requirements for this satellite uplink scenario.\n'); 