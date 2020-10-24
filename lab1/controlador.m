function [u] = controlador(f2, h1, g1, g2, g3, u_1, r, y, y_1, y_2)
    u = -f2*u_1 + h1*r -g1*y - g2*y_1 - g3*y_2;
end