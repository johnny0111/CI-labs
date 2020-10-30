%%% Script para testar o controlador%%%
clear all, close, clc

Ref = zeros(1,1000);
Ref(1:200) = 2;
Ref(200:400) = 4;
Ref(400:600) = 3;
Ref(600:800) = 4.5;
Ref(800:1000) = 3;

Ts = 0.08; % Definir intervalo de amostragem

usbinit% Inicializa��o da placa de aquisi��o

A = [ 1 -1.504 0.8344 -0.2358 ]; % Identifica��o em diferido �polin�mio A
B = [ 0 0 0.1037]; % Identifica��o em diferido �polin�mio B
na=3;
nb=1;
nk=2;
n = na + nb;
Tetak = [A(2:end) B(3)]' % vector de par�metriza��o

Lambda = 0.95; %fator de esquecimento
P = 10*eye(4); % n = dim(tetak)
phi_k = [0,0,0,0]'

disp('Em modo controlo!') 

for index= 1:length(Ref)
    y(index,1)= usbread(0);
    tic % Inicia cron�metro

    if index<= max(na,nb+nk)
        u(index,1) = Ref(index);
    else
        [Tetak, P] = rlsteta(Tetak, P, phi_k, n, Lambda, y(index,1)); % Adapta��o em-linha dos par�metros do modelo
        phi_k = [-y(index-1,1), -y(index-2,1), -y(index-3,1), u(index-2,1)]';
        [F, G, H] = tuning([1 Tetak(1) Tetak(2) Tetak(3)],[0 0 Tetak(4)]);   
        u(index,1)= controlador(Ref(index), F, G, H, y(index-2:index,1), u(index-1,1)); % calcula a ac��o de controlo
    end
    u(index,1) = max(min(u(index,1),5),0); % Satura��o da excita��o [0, 5]V
    usbwrite(u(index),0)
    Dt= toc; % Stop cron�metro
    pause(Ts-Dt)
end

usbwrite(0,0)
save expdata_adapt_0.95.mat Ref u y -mat