clc; clear; close all;

A = 1;             
fc = 1000;         
Ts = 5/fc;     
m_t = A * sin(2 * pi * fc * t); 

fs = 5000;         
Ts_pam = 1/fs;      

m_pam_inst = zeros(size(t)); 
for i = 1:length(t)
    if mod(t(i), Ts_pam) < Ts 
        m_pam_inst(i) = m_t(i);
    end
end

figure;
subplot(2,1,1);
plot(t, m_t, 'b', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Sinusoidal Original');
grid on;

subplot(2,1,2);
stem(t, m_pam_inst, 'g', 'MarkerSize', 3);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal PAM con Muestreo Instantáneo');
grid on;