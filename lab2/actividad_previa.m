clear; clc; close all;
f0 = 1; % frecuencia base en hz
alpha_values = [0, 0.25, 0.75, 1]; % valores de roll-off a evaluar
b = f0 * (1 + alpha_values); % calculo del ancho de banda para cada alpha
ts = 1 / (2 * f0); % periodo de muestreo teorico

% creacion de vectores de tiempo y frecuencia
t = linspace(0, 10, 1000); % desde 0 hasta 10 segundos, 1000 puntos
f = linspace(-2*max(b), 2*max(b), 1000); % desde -2b hasta +2b

figure(1);
subplot(2, 1, 1);
hold on;

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    f_delta = alpha * f0;
    
    % calculo de la respuesta al impulso h(t)
    term_sinc = sin(2*pi*f0*t) ./ (2*pi*f0*t);
    term_cos = cos(2*pi*f_delta*t);
    term_denominador = (1 - (4*f_delta*t).^2);
    h_t = 2 * f0 * term_sinc .* (term_cos ./ term_denominador);
    
    % correccion de la division por cero en t=0
    h_t(t == 0) = 2 * f0;
    
    % graficar la curva para este alpha
    plot(t, h_t, 'linewidth', 1.5, 'displayname', ['a = ', num2str(alpha)]);
end

title('Respuesta al impulso del filtro coseno alzado');
xlabel('tiempo (s)');
ylabel('amplitud');
legend('location', 'best');
grid on;
hold off;

% segunda subgrafica: respuesta frecuencial del filtro
subplot(2, 1, 2);
hold on;

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    f1 = f0 * (1 - alpha);
    f_delta = alpha * f0;
    
    % inicializar vector de respuesta en frecuencia
    h_f = zeros(size(f));
    
    % calculo de la respuesta en frecuencia h(f)
    for j = 1:length(f)
        if abs(f(j)) <= f1
            h_f(j) = 1;
        elseif abs(f(j)) < (f1 + 2*f_delta)
            h_f(j) = 0.5 * (1 + cos(pi*(abs(f(j)) - f1)/(2*f_delta)));
        else
            h_f(j) = 0;
        end
    end
    
    % graficar la curva para este alpha
    plot(f, h_f, 'linewidth', 1.5, 'displayname', ['a = ', num2str(alpha)]);
end

title('Respuesta en frecuencia del filtro coseno alzado');
xlabel('frecuencia (hz)');
ylabel('amplitud');
legend('location', 'best');
grid on;
hold off;

% ajuste automatico del aspecto de la figura
set(gcf, 'position', [100, 100, 800, 600]);
sgtitle('Analisis del filtro coseno alzado de nyquist');