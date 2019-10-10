%%*************************************************
%   Simulation of a 2-tissue compartment model with endogenous NT
%   competition (ntPET)
%   
%   Usage: model2TC
%
%   Require:
%        InputFunc(t) to define AIF
%        ode_2tc to slove ODE
%        property.m define kinetic parameters for radiotracers
%
%   Author: Hsiao-Ying Monica Wey
%   Date: Aug, 2013
%%*************************************************

%global k kr
global k k_da

%% Define scan time
t = 0:0.5:200;                            % Time in min.
tlen = length(t); 


%% Define K constants

Bmax = 54;
k = [0.17, 0.21, 0.04, 0.043];  % Striatum
% k = [0.21, 0.24, 0.22, 0.043];    % Frontal
%kp = [0.17, 0.21, 1.08/Bmax, 0.043];
%k_da = [13.5, 25]; % endogenous DA with Kon = 54*0.25
k_da = [0.25, 25]; % endogenous DA with Kon = 54*0.25


%% Define Input function

% Arterial Input;
% Defined in "InputFunc.m"
tCa = t;
Ca = InputFunc(t);

t_EN = t;
td = 60;
% NT=ntInput(t,[100, 0.8, 2.7, 0.4],td);
NT=ntInput(t,[100, 15, 1.5, 0.1],td);


%% Solve ODE

[T,C] = ode23s(@(t,c) ode_2tc_da(t,c,tCa,Ca,t_EN,NT),t,[0,0,0]);   % with dynamic term;


%% Add Noise to TAC

Cf_n = add_noise(t,C(:,1)');
Cb_n = add_noise(t,C(:,2)');
Ce_n = add_noise(t,C(:,3)');
%Cf_n = noiseModel(t,C(:,1)');
%Cb_n = noiseModel(t,C(:,2)');
%Ce_n = noiseModel(t,C(:,3)');


Cb=C(:,2)';
    Cb1=Cb(1:length(Cb)-1);
    Cb2=Cb(2:length(Cb));
%     Cb1=Cb_n(1:length(Cb_n)-1);
%     Cb2=Cb_n(2:length(Cb_n));
    dCb = Cb2-Cb1;
figure; whitebg('w'); set(gcf,'color','w');
plot(0:0.5:199.5,dCb,'k','Linewidth',2)

xlabel('Time (min.)','FontSize',14,'FontName','Arial'); 
ylabel('Radioactivity (arb. units)','FontSize',14,'FontName','Arial')
% 
% %Cb=C(:,2);

%     dCb_n = Cb2-Cb1;
% figure, plot(0:0.5:199.5,dCb_n)

% R = Cb_n(:)./Cf_n(:);

%% PLOT results

figure; whitebg('w'); 
% plot(T,Ca,'--r', T,C(:,1),'-.b',T,C(:,2),'k',T,C(:,3),':g','Linewidth',2); 
% plot(T,Ca,'--r', T,C(:,1),'-.b',T,C(:,2),'k','Linewidth',2); 
%plot(T,C(:,2),'k','Linewidth',2); 
%plot(T,Ca,'--r', T,Cf_n,'-.b',T,Cb_n,'k',T,Ce_n,':c','Linewidth',2);

plot(T,Ca,'--r', T,Cf_n,'-.b',T,Cb_n,'k','Linewidth',2); % Plot with noise
%plot(T,Ca,'--r', T,C(:,1),'-.b',T,C(:,2),'k','Linewidth',2); % Plot without noise

xlabel('Time (min.)','FontSize',14,'FontName','Arial'); 
ylabel('Radioactivity (arb. units)','FontSize',14,'FontName','Arial')
% hleg1 = legend('Arterial Input', 'Free Tracer', 'Specific Binding', 'Endogenous DA'); 
hleg1 = legend('Arterial Input', 'Free Tracer', 'Specific Binding'); 
set(hleg1,'Location','Best','FontSize',12,'FontName','Arial'); 
set(gcf,'color','w');
title('Infusion (Striatum)','FontSize',16,'fontWeight','bold','FontName','Arial');


