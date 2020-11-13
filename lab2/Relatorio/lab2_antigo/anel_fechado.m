%%% Script para testar o controlador %%%
clear all, close, clc
load ('Nets\net.mat')
load ('NetsC\netc.mat')

load('dataset_prof.mat') % PCT 37-100 (Processo Térmico)

W1c=netc.IW{1,1}
W2c=netc.LW{2,1}
B1c=netc.b{1,1}


W1=net.IW{1,1}
W2=net.LW{2,1}
B1=net.b{1,1}

 Ref = zeros(1,750);
 Ref(1:150) = 2;
 Ref(150:300) = 4;
 Ref(300:450) = 3;
 Ref(450:600) = 4.5;
 Ref(600:750) = 3;
 
a=-0.6;
Nmax=length(Ref);
u =zeros(Nmax,1);
uf=zeros(Nmax,1);
y = zeros(Nmax,1);
disp('Em modo controlo!') 

for index= 2:Nmax-1
    u(index,1) = sim(netc, [Ref(index+1) y(index,1) u(index-1,1)]');  % Fun��o do controlador
    %u(index,1) = W2c * tanh (W1c * [Ref(index+1), y(index,1), u(index-1,1)]' + B1c);

    %u(index,1)=2;
    uf(index,1) = a * uf(index-1,1) + (1-a) * u(index,1);
    uf(index,1) = max(min(uf(index,1),5),0); % Saturação da excitação
    %y(index+1,1) = sim(net,[y(index,1), uf(index,1), uf(index-1,1)]');
    y(index+1,1) =  W2 * tanh (W1 * [y(index,1), uf(index,1), uf(index-1,1)]' + B1);
    
end

% for index= 2:length(Yv)-1
% 
%     u(index,1) = sim(netc,[Yv(index+1,1), Yv(index,1), u(index-1,1)]');
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