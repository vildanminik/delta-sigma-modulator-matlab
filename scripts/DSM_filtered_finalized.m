

clear;
fs =100e6;     
f_signal = 1e3;

duration = 1/f_signal;

t = 0:1/fs:duration;
u = .5* sin(2*pi*f_signal*t);   


OSRs = [8, 16, 32, 64];             % OSR seti
deltav_values = linspace(0.01, 2, 200);  % Eşik değerleri





v=deltaSigmaModulatorFunction(u,deltav_values);
N=length(u);
%% LPF - alternatif olarak lpf ile filtreleme
    % f_cutoff = 2e3;                           
    % norm_cutoff = f_cutoff / (fs/2);          % Nyquist
    % 
    % coef = fir1(128, norm_cutoff, blackman(129));  %fir1(64, norm_cutoff, 'low', blackman(65)) vardı sildim
    % u_rec = filtfilt(coef, 1, v); 

%% Ideal filter lpf 
fc = 2e3;   %cutoff
Vf = fftshift(fft(v)); % -fs/2 ve fs/2'yi merkez alacak şekilde frekans eksenini ortalandı
f = linspace(-fs/2, fs/2, N); %frekans ekseni oluşturuldu
H = double(abs(f) <= fc); %h=0 olduğunda geçirme
Yf = Vf .* H;
y_filtered= ifft(ifftshift(Yf)); %inverse fft

for OSR = OSRs
    for deltav = deltav_values
        v = deltaSigmaModulatorFunction(u, deltav);
    end
end

%% SNR 
signal_amp = sqrt(mean(u.^2));
noise_amp = sqrt(mean((y_filtered - u).^2));
accuracy = 20*log10(signal_amp/noise_amp); %2.966*10.^(-10)
fprintf('Accuracy of the system = %.2f \n', accuracy);


%% Frekans domaininde SNR hesaplama 


Vf2 = fftshift((fft(y_filtered)))/N;
Vf_mag = abs(Vf2).^2;

bw = 100; 
signal_bins=(f>=f_signal-bw & f<=f_signal+bw) | (f>=-f_signal-bw & f<=-f_signal+bw);
P_signal=sum(Vf_mag(signal_bins));
P_total= sum(Vf_mag(1:floor(N)));
P_noise = P_total-P_signal;


SNR_dB = 10 * log10(P_signal / P_noise);
fprintf('SNR: %.2f dB\n', SNR_dB);




% %% 
% %%
% figure;
% plot(f/1e3, 10*log10(Vf_mag)); % dB cinsinden çizim
% xlabel('Frequency (kHz)');
% ylabel('Magnitude (dB)');
% title('Power Spectrum of y\_filtered');
% grid on;
% xlim([-5e3, 5e3]/1e3); % -5 kHz ile 5 kHz arası gör



%%
figure;
subplot(3,1,1);
plot(t(1:fs/f_signal), u(1:fs/f_signal));
title('input signal (u)');
xlabel('time (s)');
ylabel('amplitude');
grid on;

subplot(3,1,2);
stairs(t(1:fs/f_signal), v(1:fs/f_signal));  
title('Delta-Sigma output (v)');
xlabel('time (s)');
ylabel('amplitude');
ylim([-1.5 1.5]);  
grid on;

subplot(3,1,3);
plot(t(1:fs/f_signal), y_filtered(1:fs/f_signal));
title('filtered output');
xlabel('time (s)');
ylabel('amplitude');
grid on;
% PSD Çizimi için Kod
figure;
N = length(v);
window = hann(N); % Pencereleme (Spectral leakage önlemek için)
[pxx, f] = periodogram(v, window, N, fs);

semilogx(f, 10*log10(pxx)); % Logaritmik eksen
grid on;
title('Power Spectral Density (PSD) of Modulator Output');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
xlim([100 fs/2]); % Görünürlüğü artırmak için zoom