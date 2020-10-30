clear all, close, clc

load expdata_adapt_0.95.mat

subplot(2,1,1), plot(y(1:end),'r'),hold on, plot(Ref(1:end),'g'),hold off,
title('Resposta do sistema em anel fechado')
ylabel('Sa�da'), xlabel('Amostra')
subplot(2,1,2), plot(u(1:end))
title('Actua��o')
ylabel('Ac��o de controlo'), xlabel('Amostra')