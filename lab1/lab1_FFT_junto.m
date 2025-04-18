% codigo matlab para generar modulacion pam y calcular su fft
clear; clc; close all;

%% parametros de la senal de base
amp = 1;                      % amplitud de la senal
fc = 1000;                    % frecuencia portadora
dt = 1/100000;                % periodo de muestreo
t_fin = 0.01;                 % duracion total de la senal
tiempo = 0:dt:t_fin;          % vector de tiempos
senal_base = amp * sin(2*pi*fc*tiempo);  % generacion de la senal sinusoidal

%% parametros para modulacion pam natural
fmu_nat = 5000;             % frecuencia de muestreo para pam natural
Tmu_nat = 1/fmu_nat;         % periodo de muestreo en pam natural
dc_nat = 0.8;                % ciclo de trabajo para pam natural
ancho_nat = dc_nat * Tmu_nat;  % ancho del pulso en pam natural

%% parametros para modulacion pam instantaneo
fmu_inst = 5000;             % frecuencia de muestreo para pam instantaneo
Tmu_inst = 1/fmu_inst;       % periodo de muestreo en pam instantaneo
dc_inst = 0.1;               % ciclo de trabajo para pam instantaneo
T_senal = 1/fc;              % periodo de la senal base
ancho_inst = dc_inst * T_senal;  % ancho del pulso en pam instantaneo

%% modulacion pam natural
pam_nat = zeros(size(tiempo));        % vector para pam natural
instantes_nat = 0:Tmu_nat:tiempo(end);  % instantes de muestreo para pam natural
for i = 1:length(instantes_nat)
    [~, ind] = min(abs(tiempo - instantes_nat(i)));
    indices_pulso = find(tiempo >= instantes_nat(i) & tiempo < instantes_nat(i) + ancho_nat);
    pam_nat(indices_pulso) = senal_base(ind);
end

%% modulacion pam instantaneo
pam_inst = zeros(size(tiempo));         % vector para pam instantaneo
instantes_inst = 0:Tmu_inst:tiempo(end);  % instantes de muestreo para pam instantaneo
for i = 1:length(instantes_inst)
    [~, ind] = min(abs(tiempo - instantes_inst(i)));
    indices_pulso = find(tiempo >= instantes_inst(i) & tiempo < instantes_inst(i) + ancho_inst);
    pam_inst(indices_pulso) = senal_base(ind);
end

%% calculo de la transformada de fourier
N = length(tiempo);                      % numero de puntos de la senal
f_nyquist = 1/(2*dt);                    % frecuencia de nyquist
freq = linspace(0, f_nyquist, N/2);       % vector de frecuencias

fft_senal = abs(fft(senal_base)/N);      % fft de la senal de base
fft_senal = fft_senal(1:N/2);              % solo parte positiva

fft_pam_nat = abs(fft(pam_nat)/N);        % fft de pam natural
fft_pam_nat = fft_pam_nat(1:N/2);

fft_pam_inst = abs(fft(pam_inst)/N);      % fft de pam instantaneo
fft_pam_inst = fft_pam_inst(1:N/2);

%% graficar la fft de las senales
figure;
plot(freq, fft_senal, 'b', 'LineWidth', 1.5); hold on;
plot(freq, fft_pam_nat, 'r', 'LineWidth', 1.5);
plot(freq, fft_pam_inst, 'g', 'LineWidth', 1.5);
legend('Señal base', 'PAM natural', 'PAM instantáneo');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
title('Transformada de Fourier de las Señales');
grid on;
