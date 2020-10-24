function [Fc, Gc, H] = tuning(A,B)

syms f1 f2 g0 g1 g2 

F = [1 f1 ];
G = [g0 g1 g2];

Af = sconv(A,F) + sconv(B,G);

Am = poly([0.2 0.5 0.7]); %localizacao dos polos

Aff = Af(2:end);
Amm = Am(2:end);

eqns = [Aff(1) == Amm(1), Aff(2) == Amm(2), Aff(3) == Amm(3), Aff(4) == Amm(4)];
S = solve(eqns,[f1 g0 g1 g2]);

f1c = vpa(S.f1);
g0c = vpa(S.g0);
g1c = vpa(S.g1);
g2c = vpa(S.g2);

Fc = [1 f1c]
Gc = [g0c g1c g2c]

h0 = (sum(A)*sum(Fc)+sum(B)*sum(Gc))/sum(B);
H = [h0];
end