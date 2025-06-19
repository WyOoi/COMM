%% Satellite Data Uplink for Remote Agricultural Farms - Scenario Analysis
% This script analyzes the requirements for a satellite data uplink from 
% remote agricultural farms and provides recommendations based on simulation results.

%% Scenario Description
% Remote agricultural farms need to transmit data to satellites for:
% 1. Weather monitoring and forecasting
% 2. Crop health and soil moisture monitoring
% 3. Equipment status and maintenance alerts
% 4. Yield predictions and harvest planning

%% Key Requirements Analysis
% 1. Power Efficiency: Remote farms often have limited power resources,
%    requiring modulation techniques with good power efficiency.
%
% 2. Reliability: Agricultural data is critical for decision-making,
%    so low BER is essential even in challenging conditions.
%
% 3. Moderate Data Rate: While not requiring extremely high speeds,
%    sufficient throughput is needed for periodic sensor data uploads.
%
% 4. Cost-Effective Implementation: Simple hardware implementation is
%    preferred for widespread deployment across many farms.

%% Load Simulation Results
% This assumes main.m has been run and variables are available in workspace
% If not, run main.m first
if ~exist('ber_bpsk', 'var')
    run('main.m');
end

%% Decision Matrix
% Create a decision matrix to evaluate each modulation technique
% Scoring: 1 (poor) to 5 (excellent)

% Define criteria weights (must sum to 1)
weights = [0.4, 0.3, 0.2, 0.1]; % Power efficiency, Reliability, Bandwidth efficiency, Implementation complexity

% Score matrix [BPSK, QPSK, 16-QAM]
% Rows: Power efficiency, Reliability, Bandwidth efficiency, Implementation complexity
scores = [
    5, 4, 2;  % Power efficiency (higher is better)
    5, 4, 3;  % Reliability (higher is better)
    1, 3, 5;  % Bandwidth efficiency (higher is better)
    5, 4, 2   % Implementation simplicity (higher is better)
];

% Calculate weighted scores
weighted_scores = zeros(1, size(scores, 2));
for i = 1:length(weights)
    weighted_scores = weighted_scores + weights(i) * scores(i, :);
end
[best_score, best_idx] = max(weighted_scores);

% Map index to modulation type
mod_types = {'BPSK', 'QPSK', '16-QAM'};
recommended_mod = mod_types{best_idx};

%% Display Recommendation with Justification
fprintf('\n\n===== SCENARIO ANALYSIS AND RECOMMENDATION =====\n');
fprintf('Scenario: Satellite Data Uplink for Remote Agricultural Farms\n\n');

fprintf('Key Requirements:\n');
fprintf('1. Power Efficiency: Critical due to limited power resources at remote farms\n');
fprintf('2. Reliability: Essential for accurate agricultural decision-making\n');
fprintf('3. Moderate Data Rate: Sufficient for periodic sensor data uploads\n');
fprintf('4. Cost-Effective Implementation: For widespread deployment\n\n');

fprintf('Decision Matrix (Weighted Scores):\n');
fprintf('BPSK:  %.2f\n', weighted_scores(1));
fprintf('QPSK:  %.2f\n', weighted_scores(2));
fprintf('16QAM: %.2f\n', weighted_scores(3));

fprintf('\n===== FINAL RECOMMENDATION =====\n');
fprintf('Recommended Modulation Technique: %s\n\n', recommended_mod);

% Justification based on the recommended modulation
switch recommended_mod
    case 'BPSK'
        fprintf('Justification:\n');
        fprintf('- Highest power efficiency (lowest SNR required for target BER)\n');
        fprintf('- Best reliability with lowest BER in noisy conditions\n');
        fprintf('- Simplest implementation for cost-effective deployment\n');
        fprintf('- While bandwidth efficiency is lower, the moderate data rate requirements\n');
        fprintf('  make this an acceptable trade-off for the reliability benefits\n');
        
    case 'QPSK'
        fprintf('Justification:\n');
        fprintf('- Good balance between power efficiency and bandwidth efficiency\n');
        fprintf('- Doubles the data rate compared to BPSK with minimal SNR penalty\n');
        fprintf('- Reasonably simple implementation for cost-effective deployment\n');
        fprintf('- Provides sufficient reliability for agricultural data transmission\n');
        
    case '16-QAM'
        fprintf('Justification:\n');
        fprintf('- Highest bandwidth efficiency, providing maximum data throughput\n');
        fprintf('- While power efficiency is lower, the higher data rate capability\n');
        fprintf('  enables more frequent updates or richer sensor data transmission\n');
        fprintf('- The higher SNR requirement is acceptable in scenarios where\n');
        fprintf('  satellite visibility and link quality are generally good\n');
end

%% Create Final Comparison Figure
figure;

% Create subplot for BER vs SNR
subplot(2, 2, 1);
semilogy(SNR_dB, ber_bpsk, 'b-o', 'LineWidth', 2);
hold on;
semilogy(SNR_dB, ber_qpsk, 'r-s', 'LineWidth', 2);
semilogy(SNR_dB, ber_16qam, 'g-d', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER Performance');
legend('BPSK', 'QPSK', '16-QAM', 'Location', 'southwest');

% Create subplot for spectral efficiency
subplot(2, 2, 2);
bar([spectral_efficiency_bpsk, spectral_efficiency_qpsk, spectral_efficiency_16qam]);
set(gca, 'XTickLabel', {'BPSK', 'QPSK', '16-QAM'});
ylabel('Spectral Efficiency (bits/s/Hz)');
title('Bandwidth Efficiency');
grid on;

% Create subplot for power efficiency
subplot(2, 2, 3);
bar([required_snr_bpsk, required_snr_qpsk, required_snr_16qam]);
set(gca, 'XTickLabel', {'BPSK', 'QPSK', '16-QAM'});
ylabel('Required SNR (dB) for BER = 10^{-4}');
title('Power Efficiency');
grid on;

% Create subplot for weighted scores
subplot(2, 2, 4);
bar(weighted_scores);
set(gca, 'XTickLabel', {'BPSK', 'QPSK', '16-QAM'});
ylabel('Weighted Score');
title('Overall Performance');
grid on;

% Highlight the recommended modulation
subplot(2, 2, 4);
hold on;
bar(best_idx, weighted_scores(best_idx), 'FaceColor', 'green');
hold off;

% Adjust figure layout
sgtitle('Modulation Technique Comparison for Satellite Data Uplink');
set(gcf, 'Position', [100, 100, 1000, 800]);
% saveas(gcf, 'final_comparison.png'); 