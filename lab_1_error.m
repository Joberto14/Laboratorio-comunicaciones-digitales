clc; clear; close all;

%% parametros de la senal original
amp = 1;                       % amplitud de la senal
f_carrier = 1000;              % frecuencia de la portadora
Ts = 1/100000;                 % periodo de muestreo continuo
time = 0:Ts:5/f_carrier;         % vector de tiempos
signal_orig = amp * sin(2*pi*f_carrier*time);  % generacion de la senal sinusoidal

%% modulacion pam instantaneo
fs_pam = 5000;                 % frecuencia de muestreo para pam
T_pam = 1/fs_pam;              % periodo de la senal pam
pam_inst = zeros(size(time));  % inicializacion del vector pam instantaneo
for k = 1:length(time)
    if mod(time(k), T_pam) < Ts
        pam_inst(k) = signal_orig(k);
    end
end

%% cuantificacion pcm de la senal pam instantanea
bits = 2;                      % numero de bits para la codificacion pcm (configurable)
levels = 2^bits;               % numero de niveles de cuantificacion
max_val = max(abs(pam_inst));   % valor maximo de la senal pam instantanea
delta = 2 * max_val / levels;   % resolucion de cuantificacion

pcm_signal = delta * floor(pam_inst / delta + 0.5);  % generacion de la senal cuantificada

%% calculo del error de cuantificacion
error_quant = pam_inst - pcm_signal;

%% graficacion de las senales y el error
figure;
subplot(3,1,1);
plot(time, signal_orig, 'b', time, pam_inst, 'r', 'LineWidth', 1.5);
title('Senal original VS PAM instantaneo');
legend('Original', 'PAM instantáneo');
grid on;

subplot(3,1,2);
stairs(time, pcm_signal, 'k', 'LineWidth', 1.5); % senal pcm
hold on;
plot(time, pam_inst, 'r--');
title(['Señal cuantificada (n = ', num2str(bits), ' bits)']);
legend('Señal cuantificada', 'PAM instantaneo');
grid on;

subplot(3,1,3);
histogram(error_quant, 10);
title('Error de Cuantificación');
xlabel('Error');
ylabel('Frecuencia');
grid on;
