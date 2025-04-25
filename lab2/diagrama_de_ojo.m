function cosenoAlzado()
    % cosenoAlzado: realiza la generación de una señal digital 
    % NRZ-L, la filtra con un coseno alzado para diferentes roll-off,
    % añade ruido y presenta un diagrama de ojo para cada caso

    resetearEntorno();

    % Configuración de parámetros
    config = obtenerParametros();

    % Generación de la señal NRZ-L
    [senalNRZ, fs] = generarNRZL(config);

    % Procesamiento y visualización
    procesarYVisualizar(config, senalNRZ);
end

%% Funciones auxiliares
function resetearEntorno()
    clc;
    clear;
    close all;
end

function config = obtenerParametros()
    % obtenerParametros: define los parámetros necesarios para la simulación
    config = struct( ...
        'tasa_bps', 1, ...
        'cant_bits', 104, ...
        'valor_amp', 1, ...
        'fact_oversample', 40, ...
        'snr_dB', 30, ...
        'coef_rolloff', [0, 0.25, 0.75, 1], ...
        'duracion_sim', 6 ...
    );
end

function [senal, fs] = generarNRZL(config)
    % generarNRZL: crea una señal digital NRZ-L con sobremuestreo
    fs = config.tasa_bps * config.fact_oversample;
    bits = randi([0 1], 1, config.cant_bits);
    senal = config.valor_amp * repelem(2 * bits - 1, config.fact_oversample);
end

function procesarYVisualizar(config, senalNRZ)
    % procesarYVisualizar: aplica filtros RC y genera diagramas de ojo
    for beta = config.coef_rolloff
        senalRuidosa = filtrarYAnadirRuido(senalNRZ, beta, config);
        graficarOjo(senalRuidosa, 2 * config.fact_oversample, beta);
    end
end

function senalRuidosa = filtrarYAnadirRuido(senalNRZ, beta, config)
    % filtrarYAnadirRuido: aplica el filtro RC y añade ruido a la señal
    h = disenarFiltroRC(beta, config.duracion_sim, config.fact_oversample);
    senalFiltrada = conv(senalNRZ, h, 'same');
    senalRuidosa = awgn(senalFiltrada, config.snr_dB, 'measured');
end

function h = disenarFiltroRC(beta, span, sps)
    % disenarFiltroRC: diseño del filtro coseno alzado
    h = rcosdesign(beta, span, sps, 'normal');
end

function graficarOjo(senal, muestrasSimbolo, beta)
    % graficarOjo: muestra el diagrama de ojo
    figure;
    eyediagram(senal, muestrasSimbolo);
    title(sprintf('Diagrama de ojo (roll-off = %.2f)', beta));
end
