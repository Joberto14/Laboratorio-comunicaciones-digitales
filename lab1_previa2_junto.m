% codigo matlab revisado para mejorar la visualizacion de la modulacion pam
clear; clc; close all;

%% definicion de la senal original
amplitud = 1;             % valor maximo de la senal
fc = 1000;                % frecuencia de la portadora
Tmuestreo = 1/100000;      % intervalo de muestreo
t_final = 0.01;           % tiempo total de simulacion
tiempo = 0:Tmuestreo:t_final;  % vector de tiempo

% creacion de la senal sinusoidal original
senal = amplitud * sin(2*pi*fc*tiempo);

%% configuracion para pam natural
fs_nat = 5000;            % frecuencia de muestreo para pam natural
Ts_nat = 1/fs_nat;        % periodo de muestreo correspondiente
duty_nat = 0.8;           % ciclo de trabajo en pam natural
tau_nat = duty_nat * Ts_nat;  % duracion del pulso en pam natural

%% configuracion para pam instantaneo
fs_inst = 5000;           % frecuencia de muestreo para pam instantaneo
Ts_inst = 1/fs_inst;      % periodo de muestreo correspondiente
duty_inst = 0.1;          % ciclo de trabajo en pam instantaneo
T_periodo = 1/fc;         % periodo de la senal sinusoidal
tau_inst = duty_inst * T_periodo;  % duracion del pulso en pam instantaneo

%% generacion de la modulacion pam natural
pam_nat = zeros(size(tiempo));           % inicializacion del vector de modulacion
muestras_nat = 0:Ts_nat:t_final;           % instantes de muestreo para pam natural
for k = 1:length(muestras_nat)
    [~, ind] = min(abs(tiempo - muestras_nat(k)));
    idx_pulso = find(tiempo >= muestras_nat(k) & tiempo < muestras_nat(k) + tau_nat);
    pam_nat(idx_pulso) = senal(ind);
end

%% generacion de la modulacion pam instantaneo
pam_inst = zeros(size(tiempo));          % inicializacion del vector de modulacion
muestras_inst = 0:Ts_inst:t_final;         % instantes de muestreo para pam instantaneo
for k = 1:length(muestras_inst)
    [~, ind] = min(abs(tiempo - muestras_inst(k)));
    idx_pulso = find(tiempo >= muestras_inst(k) & tiempo < muestras_inst(k) + tau_inst);
    pam_inst(idx_pulso) = senal(ind);
end

figure;
plot(tiempo, senal, 'b', 'LineWidth', 1.5); hold on;
stem(muestras_nat, amplitud*sin(2*pi*fc*muestras_nat), 'r', 'filled', 'LineWidth', 1.5);
stairs(tiempo, pam_inst, 'g', 'LineWidth', 1.5);
legend('Señal original', 'PAM natural', 'PAM instantáneo');
xlabel('tiempo (s)');
ylabel('amplitud');
title('Modulación por amplitud de pulso (PAM)');
grid on;
