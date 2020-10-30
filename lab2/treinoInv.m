% Rede neuronal
clear all, close all, clc

load('dataset.mat') % PCT 37-100 (Processo Térmico)

na = 1;
nb = 2;
nk = 1;
M = length(Ue);
Unn = [Ye(1:M-1) Ye(2:M) Ue(2:M) Ue(1:M-1)]'; % 3 Entradas
%Unn = [Ye(1:M-1) Ue(2:M)]'; % 3 Entradas

Utrain = Ue(2:M); % Target
[Nu, trash] = size(Unn); % Número de entradas
Ny = 1; % Número de saídas

%OOOOOOOOOOOOOOOOOOO Topologia da Rede Neuronal

Nh = 3;
minu = min(min(Unn));
maxu = max(max(Unn));


%OOOOOOOOOOOOOOOOOOO Construção da Rede Neuronal

disp('_________________________________ Construção da Rede...')

net = newff(ones(Nu,1)*[minu maxu], [Nh Ny] ,{'tansig','purelin'}, 'trainlm' );

net = init(net);

net.biasConnect   = [ 1 1]';
net.performParam.ratio = 0.5; % Regularização 
net.trainParam.epochs = 400;
net.trainParam.show = 100;
net.trainParam.goal = 1e-5;
net.performFcn = 'sse';
net.trainParam.mu_max = 1e15;

%OOOOOOOOOOOOOOOOOOO Treino da Rede Neuronal
clc
disp('_________________________________ Treino da Rede...')
disp(' ')

[net,tr] = train(net,Unn,Utrain');

W1=net.IW{1,1};
W2=net.LW{2,1};
B1=net.b{1,1};

%OOOOOOOOOOOOOOOOOOO Simulação da Rede Neuronal (Conunto de treino)

Unn = [Yv(1:M-1) Yv(2:M) Uv(2:M) Uv(1:M-1)]'; % 3 Entradas
Ynn  = sim(net,Unn);
Errs = (Utrain - Unn')' * (Utrain - Unn')


plot(Yv,'b');
hold on
plot(Ynn,'r');
