function [THETA] = theta(THETA_1, P_1, PHI, Y, Lambda)
    P = ( P_1 / Lambda ) * ( eye(6) - ( PHI * transpose(PHI) .* P_1 )/( Lambda + transpose(PHI).* P_1 * PHI)); 
    THETA = THETA_1 + P.*PHI*(Y-transpose(PHI)*THETA_1);
end
