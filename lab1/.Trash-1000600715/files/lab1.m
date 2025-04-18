clc;
clear;

Fm = 100000; 
Tm = 1/Fm;   

Ls = 200;    
Fc = 1000;   
Ac = 1;      

Fs = 20000;  
Ts = 1/Fs;   
tau = 0.5 * Ts; 
d = tau / Ts;   

t = (0:Ls-1) * Tm;

m_t = Ac * sin(2*pi*Fc*t);

subplot(3,1,1);
plot(t, m_t);
title('Señal sinusoidal m(t)');
xlabel('Tiempo (s)');
ylabel('Amplitud');

senal_cuadrada = square(2*pi*Fs*t, d * 100); 

pam_natural = m_t .* (senal_cuadrada > 0);

subplot(3,1,2);
plot(t, pam_natural);
title('Señal modulada con muestreo natural');
xlabel('Tiempo (s)');
ylabel('Amplitud');

pam_instantanea = zeros(1, length(t)); 
r = round(Ts / Tm); 
s = round(tau / Tm); 

for i = 1:length(m_t)
    if mod(i, r) == 0
        pam_instantanea(i:i+s) = m_t(i);
    end
end

subplot(3,1,3);
stem(t, pam_instantanea, 'filled'); 
title('Señal modulada con muestreo instantáneo');
xlabel('Tiempo (s)');
ylabel('Amplitud');
