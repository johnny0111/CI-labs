%%% Script para testar o controlador %%%
clear all, close, clc
load ('Nets\net.mat')
load ('NetsC\netc.mat')

load('dataset_prof.mat') % PCT 37-100 (Processo Térmico)


 Ref = zeros(1,750);
 Ref(1:150) = 2;
 Ref(150:300) = 4;
 Ref(300:450) = 3;
 Ref(450:600) = 4.5;
 Ref(600:750) = 3;
 
a=-0.2;
Nmax=length(Ref);
u =zeros(Nmax,1);
uf=zeros(Nmax,1);
y = zeros(Nmax,1);
disp('Em modo controlo!') 

for index= 3:Nmax-1
    u(index,1) = sim(netc, [Ref(index+1) y(index,1) u(index-1,1)]');  % Fun��o do controlador
    %u(index,1)=2;
    uf(index,1) = a * uf(index-1,1) + (1-a) * u(index,1);
    uf(index,1) = max(min(uf(index,1),5),0); % Saturação da excitação
 
    y(index+1,1) = sim(net,[y(index,1), uf(index,1), uf(index-1,1)]');
end

% for index= 2:length(Ye)-1
% 
%     u(index,1) = sim(net,[Yv(index+1,1), Yv(index,1), u(index-1,1)]');
% end

% for index= 2:length(Ue)-1
% 
%     y(index+1,1) = sim(net,[y(index,1), Uv(index,1), Uv(index-1,1)]');
% end

subplot(2,1,1), plot(y(3:end),'r'), hold on, plot(Ref(3:end),'b'),hold off,
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(3:end))
title('Actuação')
ylabel('Acçãode controlo'), xlabel('Amostra')