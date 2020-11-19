% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Controlo Inteligente, NOVA-DEEC
% Controlador PI - Difuso
% Exemplo de simulação usando a função pifuzzy
% Usando um modelo ARX(3,2,1) com ruido Gaussiano
% Paulo Gil, Novembro 2020
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

clear all, close,clc

load('modelpar.mat') % ARX(3,2,1)

fuzzyInf = readfis('pifuz.fis'); % Fuzzy Structure

r = [2*ones(150,1);4*ones(150,1);3*ones(150,1); 4.5*ones(150,1);3*ones(150,1)]; 
N = length(r);
Ts = 0.08; % Intervalo de amostragem 80 ms

% ********************************** Parameterizacao
ubound = [0 5];
error = 0;
derror = 0;
Kerror = 0.7;
Kderror = .4;
a = 0.015;
Kdu = a*diff(ubound);
% *************************************************

u = zeros(N,1);
y = zeros(N,1);

for index = 4 : N
    if index <= 3
        u(index,1) = 0.01;
    else
        error = r(index)-y(index);
        derror = r(index)-r(index-1)-y(index)+y(index-1);
        u(index,1)=pifuzzy(fuzzyInf, error, derror, Kerror, Kderror, Kdu, u(index-1,1), ubound);
    end
    y(index+1) = -theta(1)*y(index,1)-theta(2)*y(index-1,1)-theta(3)*y(index-2,1)+...
    theta(4)*u(index,1)+theta(4)*u(index-1,1)+0.05*randn;
  
end

time = (0:1:N)'*Ts;
subplot(2,1,1), plot(time,y,'b'),hold on, plot(time(2:end),r,'g'), hold off
title('Controlo PI-Difuso')
xlabel({'Tempo [s]'},'Interpreter', 'Latex')
ylabel({'Temperatura [V]'}, 'Interpreter', 'Latex')
legend('Saída','Referência','location','best')
subplot(2,1,2), stairs(time(1:end-1), u)
xlabel({'Tempo [s]'},'Interpreter', 'Latex')
ylabel({'Tens\~ao [V]'},'Interpreter', 'Latex')
axis([0 time(end) 0 5])