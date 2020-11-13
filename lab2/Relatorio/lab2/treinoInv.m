% Rede neuronal
clear all, close all, clc

load('dataset_prof.mat') % PCT 37-100 (Processo Térmico)

Nsimax = 5;
M = length(Ue);
Unn = [Ye(2:M) Ye(1:M-1) Ue(1:M-1)]'; % 3 Entradas
Uvv = Uv(2:M);
Utrain = Ue(2:M); % Target
[Nu, trash] = size(Unn); % Número de entradas
Ny = 1; % Número de saídas

%OOOOOOOOOOOOOOOOOOO Topologia da Rede Neuronal

Nh = 3;
minu = min(min(Unn));
maxu = max(max(Unn));


%OOOOOOOOOOOOOOOOOOO Construção da Rede Neuronal

disp('_________________________________ Construção da Rede...')


for Nsim = 1:Nsimax
netc = newff(ones(Nu,1)*[minu maxu], [Nh Ny] ,{'tansig','purelin'}, 'trainlm' );

netc = init(netc);

netc.biasConnect   = [ 1 0]';
netc.performParam.ratio = 0.5; % Regularização 
netc.trainParam.epochs = 400;
netc.trainParam.show = 100;
netc.trainParam.goal = 1e-5;
netc.performFcn = 'sse';
netc.trainParam.mu_max = 1e15;

%OOOOOOOOOOOOOOOOOOO Treino da Rede Neuronal
clc
disp('_________________________________ Treino da Rede...')
disp(' ')

[netc,tr] = train(netc,Unn,Utrain');

end

W1=netc.IW{1,1};
W2=netc.LW{2,1};
B1=netc.b{1,1};

%OOOOOOOOOOOOOOOOOOO Simulação da Rede Neuronal (Conunto de treino)

Unn = [Yv(2:M) Yv(1:M-1) Uv(2:M)]'; % 3 Entradas
Ynn  = sim(netc,Unn);
Errs = (Utrain - Unn')' * (Utrain - Unn')


plot(Uvv,'b');
hold on
plot(Ynn,'r');
%eval(['load NetsC\' netopt '.mat']);
save('NetsC\netc.mat', 'netc', '-mat', '-v7.3')
