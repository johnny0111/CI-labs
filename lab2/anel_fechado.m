%%% Script para testar o controlador %%%
clear all, close, clc
load ('Nets\net.mat')
load ('NetsC\netc.mat')

 Ref = zeros(1,1000);
 Ref(1:150) = 2;
 Ref(150:300) = 4;
 Ref(300:450) = 3;
 Ref(450:600) = 4.5;
 Ref(600:750) = 3;
 
a=0.9;
Nmax=length(Ref);
u =zeros(Nmax,1);
uf=zeros(Nmax,1);
y = zeros(Nmax,1);
disp('Em modo controlo!') 

for index= 3:Nmax-1
    u(index,1) = sim(netc, [Ref(index+1) y(index,1) u(index-1,1) u(index-2,1)]');  % Fun��o do controlador
    u(index,1) = max(min(u(index,1),5),0); % Saturação da excitação
    uf(index,1) = a * uf(index-1,1) + (1-a) * u(index-1,1);
    y(index+1,1) = sim(net,[y(index,1), uf(index,1), uf(index-1,1)]');
end

subplot(2,1,1), plot(y(3:end),'r'), hold on, plot(Ref(3:end),'b'),hold off,
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(3:end))
title('Actuação')
ylabel('Acçãode controlo'), xlabel('Amostra')