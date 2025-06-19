# Digital Modulation Decision-Maker: Satellite Data Uplink for Remote Agricultural Farms

This project simulates and compares different digital modulation techniques for a satellite uplink communication system from remote agricultural farms. The goal is to identify the most suitable modulation technique based on the specific requirements of the scenario.

## Scenario Description

Remote agricultural farms need to transmit data to satellites for:
1. Weather monitoring and forecasting
2. Crop health and soil moisture monitoring
3. Equipment status and maintenance alerts
4. Yield predictions and harvest planning

## Key Requirements

1. **Power Efficiency**: Remote farms often have limited power resources, requiring modulation techniques with good power efficiency.
2. **Reliability**: Agricultural data is critical for decision-making, so low BER is essential even in challenging conditions.
3. **Moderate Data Rate**: While not requiring extremely high speeds, sufficient throughput is needed for periodic sensor data uploads.
4. **Cost-Effective Implementation**: Simple hardware implementation is preferred for widespread deployment across many farms.

## Modulation Techniques Compared

1. **BPSK** (Binary Phase Shift Keying)
2. **QPSK** (Quadrature Phase Shift Keying)
3. **16-QAM** (16-Quadrature Amplitude Modulation)

## Files in this Project

- `main.m`: Main script that runs the simulation and generates initial comparison plots
- `simulate_modulation.m`: Function that simulates different modulation techniques and calculates BER
- `scenario_analysis.m`: Script that analyzes the scenario requirements and provides recommendations
- `README.md`: This file

## How to Run the Simulation

1. Make sure you have MATLAB installed with the Communications Toolbox
2. Clone or download this repository
3. Open MATLAB and navigate to the project directory
4. Run the main script:
   ```matlab
   run main.m
   ```
5. Run the scenario analysis script:
   ```matlab
   run scenario_analysis.m
   ```

## Output Files

The simulation generates several output files:
- `ber_comparison.png`: Plot of BER vs SNR for each modulation technique
- `bandwidth_efficiency.png`: Comparison of spectral efficiency
- `power_efficiency.png`: Comparison of required SNR for target BER
- `final_comparison.png`: Comprehensive comparison of all metrics

## Evaluation Metrics

- **BER vs SNR**: Measures the reliability of each modulation technique
- **Spectral Efficiency**: Measures bandwidth usage (bits/s/Hz)
- **Power Efficiency**: Measures required SNR for a target BER
- **Implementation Complexity**: Considers hardware requirements

## Decision Matrix

The final recommendation is based on a weighted decision matrix that considers:
- Power efficiency (40% weight)
- Reliability (30% weight)
- Bandwidth efficiency (20% weight)
- Implementation complexity (10% weight)

## Requirements

- MATLAB R2019b or newer
- Communications Toolbox 