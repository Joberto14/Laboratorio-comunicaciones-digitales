% codigo matlab para modulacion pcm a partir de la senal muestreada instantaneamente
clear; clc; close all;

%% parametros de la senal original
amp = 1;                  % amplitud de la senal
fc = 1000;                % frecuencia portadora
T_muestreo = 1/100000;    % periodo de muestreo continuo
t_fin = 0.01;             % tiempo final de la simulacion
tiempo = 0:T_muestreo:t_fin;  % vector de tiempos
senal = amp * sin(2*pi*fc*tiempo);  % generacion de la senal original

%% parametros para pam instantaneo
fs_inst = 5000;           % frecuencia de muestreo para pam instantaneo
T_inst = 1/fs_inst;       % periodo de muestreo pam
duty_inst = 0.1;          % ciclo de trabajo para pam instantaneo
T_senal = 1/fc;           % periodo de la senal original
ancho_inst = duty_inst * T_senal;  % ancho del pulso para pam instantaneo

%% generacion de pam instantaneo
pam_inst = zeros(size(tiempo));  % vector para pam instantaneo
instantes = 0:T_inst:tiempo(end);  % instantes de muestreo
for i = 1:length(instantes)
    [~, idx] = min(abs(tiempo - instantes(i)));
    indices_pulso = find(tiempo >= instantes(i) & tiempo < instantes(i) + ancho_inst);
    pam_inst(indices_pulso) = senal(idx);
end

%% modulacion pcm: cuantificacion de pam instantaneo
N_bits = 3;                % numero de bits para la codificacion pcm (configurable)
L = 2^N_bits;              % numero de niveles de cuantificacion
niveles = linspace(-amp, amp, L);  % niveles de cuantificacion uniformes

pam_pcm = pam_inst;        % inicializacion de la senal cuantificada
for i = 1:length(pam_pcm)
    if pam_pcm(i) ~= 0
        [~, ind] = min(abs(niveles - pam_pcm(i)));
        pam_pcm(i) = niveles(ind);
    end
end

%% graficar senales: senal original, pam instantaneo y pam cuantificado
figure;
plot(tiempo, senal, 'b', 'LineWidth', 1.5); hold on;
stem(instantes, amp*sin(2*pi*fc*instantes), 'r', 'filled', 'LineWidth', 1.5);
stairs(tiempo, pam_pcm, 'g', 'LineWidth', 1.5);
legend('senal original', 'pam instantaneo', 'pam cuantificado');
xlabel('tiempo (s)');
ylabel('amplitud');
title('senal original, pam instantaneo y pam cuantificado');
grid on;
