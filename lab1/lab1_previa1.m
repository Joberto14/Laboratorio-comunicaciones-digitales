clc; clear; close all;  

A = 1;               % amplitud de la senal sinusoidal
fc = 1000;           % frecuencia de la senal sinusoidal (hz)
Ts = 1/100000;       % periodo de muestreo para la senal
t = 0:Ts:5/fc;       % vector de tiempo, de 0 a 5 periodos de la senal
m_t = A * sin(2 * pi * fc * t);  % genera la senal sinusoidal

fs = 5000;           % frecuencia de muestreo para pam
Ts_pam = 1/fs;       % periodo de muestreo para pam
d = 0.2;             % factor de duracion del pulso (ciclo de trabajo)
tau = d * Ts_pam;    % duracion del pulso

pulsos_natural = zeros(size(t));  % crea un vector de pulsos lleno de ceros
for i = 1:length(t)
    if mod(t(i), Ts_pam) < tau  % si el tiempo actual esta dentro del intervalo del pulso
        pulsos_natural(i) = 1;   % asigna 1 para indicar pulso activo
    end
end

m_pam_natural = m_t .* pulsos_natural;  % modula la senal sinusoidal con el tren de pulsos

figure;
subplot(3,1,1);
plot(t, m_t, 'b', 'LineWidth', 1.5);
xlabel('tiempo (s)');
ylabel('amplitud');
title('Señal sinusoidal original');
grid on;

subplot(3,1,2);
plot(t, pulsos_natural, 'r', 'LineWidth', 1.5);
xlabel('tiempo (s)');
ylabel('amplitud');
title('Tren de pulsos (muestreo natural)');
grid on;

subplot(3,1,3);
plot(t, m_pam_natural, 'g', 'LineWidth', 1.5);
xlabel('tiempo (s)');
ylabel('amplitud');
title('Senal PAM con muestreo natural');
grid on;
