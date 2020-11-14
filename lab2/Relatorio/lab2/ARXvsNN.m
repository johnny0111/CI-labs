%comparacao da rede neuronal utilizada com o modelo arx do primeiro
%trabalho

load ('Nets\net4.mat')
load('dataset_prof.mat') % PCT 37-100 (Processo Térmico)

Nmax = length(Uv) - 1
 
%ARX(3,1,2)
A = [ 1 -1.504 0.8344 -0.2358 ];
B = [ 0 0 0.1037];

y = zeros(length(Uv),1);
yNN = zeros(Nmax,1);
erro = zeros(length(Uv),1);
erroNN = zeros(length(Uv),1);

for index = 3:Nmax
    y(index+1,1) = -A(2)*y(index,1)-A(3)*y(index-1,1) -A(4)*y(index-2,1) + B(1)*Uv(index,1) + B(2)*Uv(index-1,1) + B(3)*Uv(index-2,1);
    erro(index+1) = y(index+1,1)-Yv(index+1,1);
end

for index = 3:Nmax
    yNN(index) = sim(net,[yNN(index-1,1), Uv(index-1,1), Uv(index-2,1)]');
    erroNN(index+1) = yNN(index,1)-Yv(index,1);
end

errosqrARX=sumsqr(erro)
errosqrNN=sumsqr(erroNN)

plot ( 1,1), plot (y(1:Nmax),'r'), hold on, plot (Yv(1:Nmax),'b'), plot (yNN(1:end),'g'), hold off