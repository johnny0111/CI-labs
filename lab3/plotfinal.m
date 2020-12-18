clear all, close, clc

load expdata_exp2.mat

err = immse(r,y)

subplot(2,1,1), plot(y(1:end),'r'),hold on, plot(r(1:end),'g'),hold off,
title('Resposta do sistema em anel fechado')
ylabel('Temperatura [V]'), xlabel('Tempo [s]')
subplot(2,1,2), plot(u(1:end))
title('Actuação')
ylabel('Tensão [V]'), xlabel('Tempo [s]')