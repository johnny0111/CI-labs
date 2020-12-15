%%% Script para testar o controlador%%%
clear all, close,clc

r = [2*ones(150,1);4*ones(150,1);3*ones(150,1); 4.5*ones(150,1);3*ones(150,1)]; 
Ts =  0.08; % Definir intervalo de amostragem
usbinit% Inicialização da placa de aquisição

fuzzyInf = readfis('pifuz.fis'); % Fuzzy Structure
M = 3;
L = 0.5;
T = 1.5;
KI = L/0.3;
KP = 0.9 * (T/L);
TI = KP/KI;
% ********************************** Parameterizacao
ubound = [0 5];
error = 0;
derror = 0;
%Kerror = 0.75;
Kerror = 0.8* (1/M);
%Kderror = .5;
Kderror = 1.3*(TI/M);
a = 0.015;
%Kdu = a*diff(ubound);
Kdu = 0.5*(KP*M*Ts)/TI;
% *************************************************

u = zeros(N,1);


for index= 1:length(Ref)
    y(index,1)= usbread(0)
    tic% Inicia cronómetro
%     if index<= max(na,nb+nk)
%         u(index,1) = Ref(index)
%     else
        error = r(index)-y(index);
        derror = r(index)-r(index-1)-y(index)+y(index-1);
        u(index,1)=pifuzzy(fuzzyInf, error, derror, Kerror, Kderror, Kdu, u(index-1,1), ubound);
%     end
        u(index,1) = max(min(u(index,1),5),0); % Saturação da excitação
        usbwrite(u(index),0)
        Dt = toc; % Stop cronómetro
        pause(Ts-Dt)
end
usbwrite(0,0)

erro = sumsqr(erro);

subplot(2,1,1), plot(y(1:end),'r'),hold on, plot(r(1:end),'g'),hold off,
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(1:end))
title('Actuação')
ylabel('Acção de controlo'), xlabel('Amostra')

save expdata.mat r u y -ma