
function [Fc, Gc, H] = tuning(A,B)

syms f1 f2 g0 g1 g2 a1 a2 a3 a4 b1 b2 b3
 a2 = A(2); 
 a3 = A(3);
 a4 = A(4);
 b3 = B(3);
%F = [1 f1];
%G = [g0 g1 g2];
M = [1, 0, 0, 0; a2, b3, 0, 0; a3, 0, b3, 0; a4, 0, 0, b3];
b = [-1.4-a2; -a3+0.67; -a4-0.126; 0.0072];




%Af = sconv(A,F) + sconv(B,G);

%[0.1 0.3 0.4 0.5] overshoot de 4%

%[0.1 0.4 0.5 0.6] overshoot de 2%

%[0.1 0.3 0.4 0.6] overshoot de 2,5% MELHOR, resposta rapida
% Am = poly([0.1 0.3 0.4 0.6]) %localizacao dos polos
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
 Z = M\b;
 f1 = Z(1);
 g0 = Z(2);
 g1 = Z(3);
 g2 = Z(4);
 Fc = [1 f1];
 Gc = [g0 g1 g2];




h0 = (sum(A)*sum(Fc)+sum(B)*sum(Gc))/sum(B);
H = [h0];

end