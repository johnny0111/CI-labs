
%%% Script para testar o controlador %%%
clear all, close, clc
load arx241.mat
 Ref = zeros(1,1000);
 Ref(1:200) = 2;
 Ref(200:400) = 4;
 Ref(400:600) = 3;
 Ref(600:800) = 4.5;
 Ref(800:1000) = 3;

% ARX(3,1,2)
% A = [ 1 -1.504 0.8344 -0.2358 ];
% B = [ 0 0 0.1037];
A = arx241.A;
Bq = arx.B;
B=Bq(2:end);

[F, G, H]=tuning(A,B);  % Parâmetros do controlador 
na=2;
nb=4;
nk=1;
Ni = max(na,nb+nk);
Nmax=length(Ref);
U =zeros(Nmax,1);
disp('Em modo controlo!')

Tetak = [A(2:end) B] % vector de parâmetrização

Lambda = 0.97; %fator de esquecimento

p = 10*eye(6); % n = dim(tetak)


y = zeros(10,1); %criei eu 
u = zeros(10,1);
[F, G, H]=tuning(A,B); % Parâmetros do controlador

for index = Ni:Nmax
    
    disp(index);
    u(index,1) = controlador();
    u(index,1) = max(min(u(index,1),5),0); % Saturação da excitação
    
    phi_k = [-y(index-1,1), -y(index-2,1), u(index,1), u(index-1,1), u(index-2,1), u(index-3,1)];
    
    y(index,1) = transpose(phi_k)*Tetak
    
    [Tetak, P] = rlsteta(Tetak, p, phi_k, na, nb, Lambda, y(index+1,1)); % Adaptação em-linha dos parâmetros do modelo
    [F, G, H]=tuning([1 Tetak(1:3)], Tetak(na+1:6)); % Parâmetros do controlador


    
end

subplot(2,1,1), plot(y(Ni:end)) 
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(Ni:end))
title('Actuação')
ylabel('Acção de controlo'), xlabel('Amostra')



% function [Tetakf, Pf] = rlsteta(Tetaki, Pi, phi_k, na, nb, Lambda, y) 
%     n = 6;
%     
%     y_ = (phi_k(6) * Tetaki(6) + (1.2*phi_k(1)*Tetaki(1) + phi_k(2) * Tetaki(2) + phi_k(3) * Tetaki(3)));
%     
%     epsilon = y - y_;
%     
%     Pf = ( Pi / Lambda ) * ( eye(n) - ( phi_k * phi_k.' * pi )/( Lambda + phi_k.' * pi * phi_k));
% 
%     [Tetakf] = Tetaki; + Pf * phi_k * epsilon;
%     
%     
% end


% function u = controlador(Ref, F, G, H, Y, u1) 
%   
%     u = ((H*Ref) -((G(1)*Y(3))+(G(2)*Y(2))+(G(3)*Y(1))) - F(2)*u1)/F(1);
%     
% end



% function [Fc, Gc, H] = tuning(A,B)
% 
% syms f1 f2 g0 g1 g2 
% 
% F = [1 f1];
% G = [g0 g1 g2];
% 
% Af = sconv(A,F) + sconv(B,G);
% 
% %[0.1 0.3 0.4 0.5] overshoot de 4%
% 
% %[0.1 0.4 0.5 0.6] overshoot de 2%
% 
% %[0.1 0.3 0.4 0.6] overshoot de 2,5% MELHOR, resposta rapida
% 
% Am = poly([0.1 0.3 0.4 0.6]); %localizacao dos polos
% 
% Aff = Af(2:end);
% Amm = Am(2:end);
% 
% eqns = [Aff(1) == Amm(1), Aff(2) == Amm(2), Aff(3) == Amm(3), Aff(4) == Amm(4)];
% S = solve(eqns,[f1 g0 g1 g2]);
% 
% f1c = vpa(S.f1);
% g0c = vpa(S.g0);
% g1c = vpa(S.g1);
% g2c = vpa(S.g2);
% 
% Fc = [1 f1c];
% Gc = [g0c g1c g2c];
% 
% h0 = (sum(A)*sum(Fc)+sum(B)*sum(Gc))/sum(B);
% H = [h0];
% 
% end
