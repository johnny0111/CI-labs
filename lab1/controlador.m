function u = controlador(Ref, F, G, H, Y, u1) 

    u = ((H*Ref) -((G(1)*Y(3))+(G(2)*Y(2))+(G(3)*Y(1))) - F(2)*u1)/F(1);

end