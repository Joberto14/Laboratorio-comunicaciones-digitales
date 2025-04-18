function simularCosenoAlzado()
    % simularcosenoalzado: realiza la generacion de una señal digital 
    % nrz-l, la filtra con un coseno alzado para diferentes roll-off,
    % añade ruido y presenta un diagrama de ojo para cada caso

    % inicializacion del entorno
    limpiarAmbiente();

    %% parametros de la simulacion
    tasa_bps = 1;           % velocidad de bits (bps)
    cant_bits = 104;        % cantidad de bits a transmitir
    valor_amp = 1;          % amplitud de la señal nrz-l
    fact_oversample = 40;   % cantidad de muestras por bit
    snr_dB = 30;            % relacion señal/ruido para el canal (db)
    
    % generacion de la señal nrz-l
    [senalNRZ, fs] = generarSenal(tasa_bps, cant_bits, valor_amp, fact_oversample);

    %% parametros del filtro coseno alzado
    coef_rolloff = [0, 0.25, 0.75, 1];  % diferentes roll-off
    duracion_sim = 6;                   % extension del filtro en simbolos

    %% procesamiento y visualizacion
    for i = 1:length(coef_rolloff)
        beta = coef_rolloff(i);
        filtroRC = crearFiltroCoseno(beta, duracion_sim, fact_oversample);
        salidaFiltrada = filtrarSenal(senalNRZ, filtroRC);
        canalRuido = awgn(salidaFiltrada, snr_dB, 'measured');
        mostrarDiagramaOjo(canalRuido, 2 * fact_oversample, beta);  % ojo de dos periodos
    end
end

%% funciones auxiliares
function limpiarAmbiente()
    clc;
    clear;
    close all;
end

function [senal, fs] = generarSenal(tasa, numBits, amp, oversample)
    % generarsenal: crea una señal digital nrz-l a partir de una secuencia
    % aleatoria de bits, aplicada la tecnica de sobremuestreo
    fs = tasa * oversample;
    datos = randi([0 1], 1, numBits);
    senal = amp * repelem(2 * datos - 1, oversample);
end

function filtro = crearFiltroCoseno(beta, span, oversample)
    % crearfiltrocoseno: diseña un filtro coseno alzado con los parametros
    % indicados
    filtro = rcosdesign(beta, span, oversample, 'normal');
end

function senalOut = filtrarSenal(senalIn, filtro)
    % filtrarsenal: aplica un filtro a la señal de entrada mediante convolucion
    senalOut = conv(senalIn, filtro, 'same');
end

function mostrarDiagramaOjo(senal, muestrasOjo, beta)
    % mostrardiagramaojo: genera el diagrama de ojo de la señal procesada
    % ojo de dos periodos
    figure;
    eyediagram(senal, muestrasOjo);
    title(sprintf('diagrama de ojo (beta = %.2f)', beta));
end
