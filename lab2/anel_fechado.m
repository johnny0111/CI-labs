%%% Script para testar o controlador %%%
clear all, close, clc
load ('D:\joaom\Documents\Mestrado\CI\CI-labs\lab2\Nets\net.mat')
load ('D:\joaom\Documents\Mestrado\CI\CI-labs\lab2\NetsC\netc.mat')
Ref= [2*eye(1,150) 4*eye(1,150) 3*eye(1,150) 4.5*eye(1,150) 3*eye(1,150)]; % Sinal de referência

Nmax=length(Ref);
u =zeros(Nmax,1);
y = zeros(Nmax,1);
disp('Em modo controlo!') 
for index= 4:Nmax
    u(index-1,1) = sim(netc, [Ref(index) y(index-1) u(index-2) u(index-3)]);  % Função do controlador
    uf(index,1) = -a * uf(index-1,1) + (1-a) * u(index-1,1);
    u(index-1,1) = max(min(u(index,1),5),0) % Saturação da excitação
    y(index,1) = sim(net,uf(index,1));
end
subplot(2,1,1), plot(y(Ni:end))
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(Ni:end))
title('Actuação')
ylabel('Acçãode controlo'), xlabel('Amostra')