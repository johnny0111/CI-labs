
%%% Script para testar o controlador %%%
clear all, close, clc

 Ref = zeros(1,1000);
 Ref(1:200) = 2;
 Ref(200:400) = 4;
 Ref(400:600) = 3;
 Ref(600:800) = 4.5;
 Ref(800:1000) = 3;

% ARX(3,1,2)
A = [ 1 -1.504 0.8344 -0.2358 ];
B = [ 0 0 0.1037];

[F, G, H]=tuning(A,B);  % Parâmetros do controlador 
na=3;
nb=1;
nk=2;
Ni = max(na,nb+nk);
Nmax=length(Ref);
U =zeros(Nmax,1);
disp('Em modo controlo!')

y = zeros(10,1); %criei eu 
u = zeros(10,1);

for index = Ni:Nmax
    u(index,1) = controlador(Ref(index), F, G, H, y(index-2:index,1), u(index-1,1)); 
    u(index,1) = max(min(u(index,1),5),0); % Saturação da excitação
    y(index+1,1) = -A(2)*y(index,1)-A(3)*y(index-1,1) -A(4)*y(index-2,1) + B(1)*u(index,1) + B(2)*u(index-1,1) + B(3)*u(index-2,1);
end

subplot(2,1,1), plot(y(Ni:end))
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(Ni:end))
title('Actuação')
ylabel('Acção de controlo'), xlabel('Amostra')