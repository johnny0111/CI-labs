%%% Script para testar o controlador %%%
clear all, close, clc
load ('Nets\net.mat')
load ('NetsC\netc.mat')

load('dataset_prof.mat') % PCT 37-100 (Processo Térmico)
load processmodel.mat;


 Ref = zeros(1,750);
 Ref(1:150) = 2;
 Ref(150:300) = 4;
 Ref(300:450) = 3;
 Ref(450:600) = 4.5;
 Ref(600:750) = 3;
 
 A = arx241.A;
 B = arx241.B;
 erro = 0;
 
a=-0.1;
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
    y_process(index+1,1) = -A(2)*y_process(index,1)- A(3)*y_process(index-1,1) + B(2)*uf(index,1) + B(3)*uf(index-1,1) + B(4)*uf(index-2,1) + + B(5)*uf(index-3,1);
    y(index+1,1) = sim(net,[y(index,1), uf(index,1), uf(index-1,1)]');
    %erro = y_process(index+1,1) - y(index+1,1)
    erro = 0;
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