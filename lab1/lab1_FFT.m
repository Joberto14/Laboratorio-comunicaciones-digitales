clc; clear; close all;

%% definicion de la senal
amp = 1;                      % amplitud de la senal
f_carrier = 1000;             % frecuencia portadora
dt = 1/100000;                % periodo de muestreo
time = 0:dt:5/f_carrier;       % vector de tiempo
signal = amp * sin(2*pi*f_carrier*time);  % generacion de la senal sinusoidal

%% configuracion de la modulacion pam
fsamp = 5000;                 % frecuencia de muestreo para pam
dt_pam = 1/fsamp;             % periodo de muestreo de pam
duty = 0.2;                   % ciclo de trabajo
pulse_width = duty * dt_pam;  % ancho del pulso

%% generacion de pam natural
pulse_nat = zeros(size(time));  % inicializacion del vector de pulsos
for i = 1:length(time)
    if mod(time(i), dt_pam) < pulse_width
        pulse_nat(i) = 1;
    end
end
pam_nat = signal .* pulse_nat;  % aplicacion de la modulacion pam natural

%% generacion de pam instantaneo
pam_inst = zeros(size(time));   % inicializacion del vector pam instantaneo
for i = 1:length(time)
    if mod(time(i), dt_pam) < dt  % condicion para muestreo instantaneo
        pam_inst(i) = signal(i);
    end
end

%% calculo de la fft
N_points = length(time);                              % cantidad de puntos
freq_vector = (0:N_points-1) * (1/dt) / N_points;      % vector de frecuencias
freq_positive = freq_vector(1:N_points/2);             % solo frecuencias positivas

fft_signal = abs(fft(signal)/N_points);               % fft de la senal original
fft_pam_nat = abs(fft(pam_nat)/N_points);             % fft de pam natural
fft_pam_inst = abs(fft(pam_inst)/N_points);           % fft de pam instantaneo

%% graficacion de las fft
figure;
subplot(3,1,1);
plot(freq_positive, fft_signal(1:N_points/2), 'b', 'LineWidth', 1.5);
title('FFT de la señal original');
xlabel('Frecuencia (hz)'); ylabel('|m(f)|');
grid on;

subplot(3,1,2);
plot(freq_positive, fft_pam_nat(1:N_points/2), 'r', 'LineWidth', 1.5);
title('FFT de pam natural');
xlabel('Frecuencia (hz)'); ylabel('|m(f)|');
grid on;

subplot(3,1,3);
plot(freq_positive, fft_pam_inst(1:N_points/2), 'g', 'LineWidth', 1.5);
title('FFT de pam instantáneo');
xlabel('Frecuencia (hz)'); ylabel('|m(f)|');
grid on;
