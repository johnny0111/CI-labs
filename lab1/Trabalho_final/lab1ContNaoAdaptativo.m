%%% Script para testar o controlador%%%
clear all, close, clc

Ref = zeros(1,1000);
Ref(1:200) = 2;
Ref(200:400) = 4;
Ref(400:600) = 3;
Ref(600:800) = 4.5;
Ref(800:1000) = 3;

Ts= 0.08; % Definir intervalo de amostragem
usbinit% Inicialização da placa de aquisição

A = [ 1 -1.504 0.8344 -0.2358 ];
B = [ 0 0 0.1037];

na=3;
nb=1;
nk=2;

[F, G, H] = tuning(A,B); % Parâmetros do controlador 
disp('Em modo controlo!') 

for index= 1:length(Ref)
    y(index,1) = usbread(0);
    tic% Inicia cronómetro
    if index <= max(na,nb+nk)
        u(index,1) = Ref(index);
    else
        u(index,1) = controlador(Ref(index), F, G, H, y(index-2:index,1), u(index-1,1)); 
    end
    u(index,1) = max(min(u(index,1),5),0); % Saturação da excitação
    usbwrite(u(index),0);
    Dt= toc; % Stop cronómetro
    pause(Ts-Dt);
end
usbwrite(0,0);
save expdata_nadapt.mat Ref u y -mat
