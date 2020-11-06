clear all, close, clc
load ('Nets\net.mat')
load ('NetsC\netc.mat')

Ref = zeros(1,1000);
Ref(1:150) = 2;
Ref(150:300) = 4;
Ref(300:450) = 3;
Ref(450:600) = 4.5;
Ref(600:750) = 3;
 
Ts = 0.8; %confirmar
a = 0.9;
 
Nmax=length(Ref);
u =zeros(Nmax,1);
uf=zeros(Nmax,1);
y = zeros(Nmax,1);

usbinit();
disp('Em modo controlo!')
 
for index = 1:legth(Ref)
    y(index,1) = usbread(0);
    tic
    if index <=2
        u(index,1) = Ref(index);
    else
        u(index,1) = sim(netc, [Ref(index+1), y(index,1), uf(index-1,1), uf(index-2,1)]');
    end

    uf(index,1) = a * uf(index-1,1) + (1-a) * u(index-1,1);
    uf(index,1) = max(min(uf(index,1),5),0); % Saturação da excitação
    usbwrite(u(index),0)
    Dt = Toc;
    pause(Ts-Dt)
 end
 usbwrite(0,0)
 save expdataDI.mat Ref u y -mat