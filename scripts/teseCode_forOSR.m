clear;
f_signal = 1e3;
fs_list = [10.^6,10.^7,10.^8,10.^9,10.^10]; % OSR
deltav_values = linspace(0.01, 10, 200);    % Thresholdlar
N = length(fs_list);
M = length(deltav_values);
SNR = zeros(N, M);


best_SNR = zeros(1, N);
best_deltav = zeros(1, N);

for i = 1:N
    fsx = fs_list(i);
    for k = 1:M
        SNR(i,k) = DSM_finalized(fsx, deltav_values(k));
    end
    [best_SNR(i), max_index] = max(SNR(i,:));
    best_deltav(i) = deltav_values(max_index);
    plot(deltav_values, SNR(i,:), 'DisplayName', ['OSR = ', num2str(fsx/f_signal)]);
    hold on;
    grid on;
end

xlabel('\DeltaV (Threshold)');
ylabel('SNR (dB)');
title('SNR vs Threshold for different OSRs');
legend show;
grid on;

% Sonuçları yazdır
fprintf('--- Optimal Thresholds for Each OSR ---\n');
for i = 1:N
    fprintf('OSR = %d:  Max SNR = %.2f dB at ΔV = %.4f\n', fs_list(i)/f_signal, best_SNR(i), best_deltav(i));
end
