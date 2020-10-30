function [Tetakf, Pf] = rlsteta(Tetaki, P, phi_k, n, Lambda, Y) 
    Pf = ( P / Lambda) * (eye(n) - ((phi_k * phi_k' * P)/(Lambda + phi_k' * P * phi_k)));
    y = phi_k'*Tetaki;
    epsilon = Y - y;
    Tetakf = Tetaki + Pf * phi_k * epsilon;
end




