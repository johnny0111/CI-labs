clc, clear all, close all

Nhmax = 6;
Nsimax = 3;
Ny = 1;

load dataset.mat

Le = length(Ye);
Lv = length(Yv);
Unet_e = [Ye(1:Le-1) Ue(2:Le) Ue(1:Le-1)];
Ynet_e = Ye(2:Le);

Unet_v = [Yv(1:Lv-1) Uv(2:Lv) Uv(1:Lv-1)];
Ynet_v = Yv(2:Lv);

[trash, Nu] = size(Unet_e);
minu = min(min(Unet_e));
maxu = max(max(Unet_e));


for Nh = 1:Nhmax
    clc
    Errosq = 10e10;
    Netid = ['Net_Nh' num2str(Nh)];
    for Nsim = 1:Nsimax
        net = newff(ones(Nu,1)*[minu maxu], [Nh Ny] ,{'tansig','purelin'}, 'trainlm' );
        net = init(net);
        net.biasConnect   = [ 1 1]';
        net.performParam.ratio = 0.5; % Regularização 
        net.trainParam.epochs = 400;
        net.trainParam.show = 100;
        net.trainParam.goal = 1e-5;
        net.performFcn = 'sse';
        net.trainParam.mu_max = 1e15;
        
        [net,tr] = train(net,Unet_e',Ynet_e');
        Ynn  = sim(net,Unet_v')';
        
        erro = (Yv(2:end) - Ynet_v);
        SEQ = erro' * erro;
        
        if SEQ <= Errosq
            Errosq = SEQ;
            eval([Netid ' = net']);
        end
        
    end
    eval(['save Nets\' Netid '.mat net']);
    Sum_sq(Nh) = Errosq;
end

idoptinet = find(Sum_sq <= min(Sum_sq));
netopt = ['Net_Nh' num2str(idoptinet)];
eval(['load Nets\' netopt '.mat']);
Ynn  = sim(net,Unet_v')';
save('Nets\net.mat', 'net', '-mat', '-v7.3')

figure(1)
plot(Yv, 'b'), hold on, plot(Ynet_v, 'r'), hold off
title('validation performance'), xlabel('Sample')

figure(2)
bar(Sum_sq), title('Sum of square error')
xlabel('Number of hidden layer neurons')
clear Net_*
delete Nets\Net_*



