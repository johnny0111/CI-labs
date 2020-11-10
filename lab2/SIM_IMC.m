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
 
%ARX(3,1,2)
A = [ 1 -1.504 0.8344 -0.2358 ];
B = [ 0 0 0.1037];
 erro = 0;
 
a=-0.4;
Nmax=length(Ref);
u =zeros(Nmax,1);
uf=zeros(Nmax,1);
y = zeros(Nmax,1);
y_process = zeros(Nmax,1);
disp('Em modo controlo!') 

for index= 4:Nmax-1
    u(index,1) = sim(netc, [Ref(index+1)-erro y(index,1) u(index-1,1)]');  % Fun��o do controlador
    uf(index,1) = a * uf(index-1,1) + (1-a) * u(index,1);
    uf(index,1) = max(min(uf(index,1),5),0); % Saturação da excitação
    y_process(index+1,1) = -A(2)*y(index,1)-A(3)*y(index-1,1) -A(4)*y(index-2,1) + B(1)*uf(index,1) + B(2)*uf(index-1,1) + B(3)*uf(index-2,1);
    y(index+1,1) = sim(net,[y(index,1), uf(index,1), uf(index-1,1)]');
    erro = y_process(index+1,1) - y(index+1,1)
end

% for index= 2:length(Ye)-1
% 
%     u(index,1) = sim(net,[Yv(index+1,1), Yv(index,1), u(index-1,1)]');
% end

% for index= 2:length(Ue)-1
% 
%     y(index+1,1) = sim(net,[y(index,1), Uv(index,1), Uv(index-1,1)]');
% end

subplot(2,1,1), plot(y(3:end),'r'), hold on, plot(Ref(3:end),'b'), plot (y_process(3:end),'g'),hold off,
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(uf(3:end))
title('Actuação')
ylabel('Acçãode controlo'), xlabel('Amostra')