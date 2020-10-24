function [Fc, Gc, H] = tuning_test(A,B)

syms f1 f2 f3 g0 g1 g2 

F = [1 f1 f2];
G = [g0 g1];

Af = sconv(A,F) + sconv(B,G);

%[0.1 0.3 0.4 0.5] overshoot de 4%

%[0.1 0.4 0.5 0.6] overshoot de 2%

%[0.1 0.3 0.4 0.6] overshoot de 2,5% MELHOR, resposta rapida

Am = poly([0.1 0.3 0.4 0.6 ]); %localizacao dos polos

Aff = Af(1:end);
Amm = Am(1:end);

eqns = [Aff(1) == Amm(1), Aff(2) == Amm(2), Aff(3) == Amm(3), Aff(4) == Amm(4), Aff(5)==Amm(5)];
S = solve(eqns,[f1 f2 g0 g1]);

f1c = vpa(S.f1);
f2c = vpa(S.f2);
g0c = vpa(S.g0);
g1c = vpa(S.g1);

Fc = [1 f1c f2c];
Gc = [g0c g1c];

h0 = (sum(A)*sum(Fc)+sum(B)*sum(Gc))/sum(B);
H = [h0];

end