%%*************************************************
%   Simulation of a 2-tissue compartment model with endogenous NT
%   competition (ntPET)
%   
%   Usage: model2TC
%
%   Requires:
%        get_InputFunc(t) to define AIF
%        ode_2tc to slove ODE
%        get_properties.m define kinetic parameters for radiotracers
%        ntInput.m to generate endogenous neurotransmitter pulse
%
%   Author: Hsiao-Ying Monica Wey (Aug, 2013)
%   Adapted by: Tom Morin
%   Date: June 2015
%%*************************************************

function plot_data = model2TC_DA_v2(tracer_props, input_func, t, competition, noise, chal_times, amplitude, handles)


global k 
global kr
global k_da
global kp

%% Define scan time
%t = 0:0.5:200;                            % Time in min.
tlen = length(t)/2; 

%% Get Model
contents = cellstr(get(handles.model,'String'));
model = contents{get(handles.model,'Value')};

%% Define K constants
[k, kp, kr, k_da] = get_k_constants(handles);

% In irreversible model, k4 = 0
if strcmp(model, cellstr('2-Tissue Irreversible'))
    if ~isnan(k)
        k(4) = 0; 
    end
    if ~isnan(kp) 
        kp(4) = 0; 
    end        
end

Bmax = 54; % Should this be different for each radiotracer?

% ====================== MONICA's CODE =============================%
%k = [0.17, 0.21, 0.04, 0.043];  % Striatum *****
% k = [0.21, 0.24, 0.22, 0.043];    % Frontal
%kp = [0.17, 0.21, 1.08/Bmax, 0.043];
%k_da = [13.5, 25]; % endogenous DA with Kon = 54*0.25
%k_da = [0.25, 25]; % endogenous DA with Kon = 54*0.25 *****
% ==================================================================%

%% Define Input function

% Arterial Input;
% Defined in "get_InputFunc.m"
tCa = t;
Ca = input_func;
%Ca = InputFunc(t); % MONICA's CODE
t_EN = t;
% If Endogenous Dopamine is selected, generate an endogenous input curve
if get(handles.competition,'Value') == 3
    num_challenges = length(chal_times);
    pulse_t = chal_times';
    base = 100;
    for m=1:num_challenges
        % NT=ntInput(t,[100, 0.8, 2.7, 0.4],td);
        temp(m,:)=ntInput(t,[base, amplitude(m), 1.5, 1],pulse_t(m));
    end
    
    % % Convolution
    % for m=1:num_challenges
    %     if m==1
    %         NT = temp(1,:);
    %     elseif m>1
    %         NT = conv(NT,temp(m,:),'same');
    %     end
    % end
    
    % % Addition
    for m=1:num_challenges
        if m==1
            NT = temp(1,:);
        elseif m>1
            for prev=1:m-1
                upper_limit = (min([(pulse_t(prev)+100);tlen]))*2;
                if pulse_t(m) < pulse_t(prev)+100
                    NT(1,pulse_t(m)*2:upper_limit) = temp(prev,pulse_t(m)*2:upper_limit) + temp(m,pulse_t(m)*2:upper_limit) - base;
                end
            end
            NT(upper_limit:end) = temp(m,upper_limit:end);
        end
    end
    
    % % Overlap
    % temporary = conv(temp(1,:),temp(2,:));
    % NT = temporary(1,1:length(t));
    % disp(NT);
    % for m=1:num_challenges
    %     if m==1
    %         NT = temp(1,:);
    %         %disp(NT);
    %     else
    %         NT(1,pulse_t(m)*2:end) = temp(m,pulse_t(m)*2:end);
    %         %disp(NT);
    %     end
    % end
    
    plot_data.NT = NT;
    
    % % Plot Endogenous NT Pulse
    % if get(handles.plot_pulse,'Value')
    %     figure;
    %     plot(t,NT,'k','Linewidth',2);
    %     xlabel('Time (min.)','FontSize',14,'FontName','Arial');
    %     ylabel('Endogenous Pulse (arb. units)','FontSize',14,'FontName','Arial')
    % end
else
    NT = zeros(1,tlen*2);
    NT(1,:)=100;
    plot_data.NT = NT;
end

%% Solve the entire ODE if Challenge is 'None' or 'Endogenous Dopamine'
if get(handles.competition,'Value') ~= 2
    [T,C] = ode23s(@(t,c) ode_2tc_da(t,c,tCa,Ca,t_EN,NT),t,[0,0,0]);   % with dynamic term;
    assignin('base','T',T);
    assignin('base','C',C);
% Solve the ODE in segments if Challenge is 'Artificial (Use k3 & k4)'
else
    k_34s = get_k_34s(handles);
    num_chals = length(chal_times);
    time_interval = [0:0.5:chal_times(1)-0.5];
    [T,C] = ode23s(@(t,c) ode_2tc_da(t,c,tCa,Ca,t_EN,NT),time_interval,[0,0,0]);
    for m=1:num_chals
        if m==num_chals
            time_interval = [chal_times(m):0.5:tlen-0.5];
        else
            time_interval = [chal_times(m):0.5:chal_times(m+1)-0.5];
        end
        k = [k(1), k(2), k_34s(1,m), k_34s(2,m)];
        if strcmp(model, '2-Tissue Irreversible')
            k(4) = 0;
        end
        [T_temp,C_temp] = ode23s(@(t,c) ode_2tc_da(t,c,tCa,Ca,t_EN,NT),time_interval,[C(end,1),C(end,2),C(end,3)]);
        T = cat(1,T,T_temp);
        C = cat(1,C,C_temp);
    end
    T = T';
end



%% Add Noise to TAC
Cf_n = noiseModel(t,C(:,1)',handles,noise);
Cb_n = noiseModel(t,C(:,2)',handles,noise);
Ce_n = noiseModel(t,C(:,3)',handles,noise);


Cb=C(:,2)';
    Cb1=Cb(1:length(Cb)-1);
    Cb2=Cb(2:length(Cb));
%     Cb1=Cb_n(1:length(Cb_n)-1);
%     Cb2=Cb_n(2:length(Cb_n));
    dCb = Cb2-Cb1;
    
    %Plot Endogenous NT Pulse(s)
% figure; whitebg('w'); set(gcf,'color','w');
% plot(0:0.5:199.5,dCb,'k','Linewidth',2)
% 
% xlabel('Time (min.)','FontSize',14,'FontName','Arial'); 
% ylabel('Radioactivity (arb. units)','FontSize',14,'FontName','Arial')

%Cb=C(:,2);

%     dCb_n = Cb2-Cb1;
% figure, plot(0:0.5:201,dCb_n)

% R = Cb_n(:)./Cf_n(:);

%% Set the Data
plot_data.x(1,:) = T; % Time axis
plot_data.y(1,:) = Ca; % Arterial Input
plot_data.x(2,:) = T;
plot_data.y(2,:) = Cf_n; % Free Tracer Compartment
plot_data.x(3,:) = T;
plot_data.y(3,:) = Cb_n; % Bound Tracer Compartment
plot_data.x(4,:) = T;
plot_data.y(4,:) = Cf_n + Cb_n; % Total Tissue Curve
assignin('base','plot_data',plot_data);


%% PLOT results

% figure; whitebg('w'); 
% % plot(T,Ca,'--r', T,C(:,1),'-.b',T,C(:,2),'k',T,C(:,3),':g','Linewidth',2); 
% % plot(T,Ca,'--r', T,C(:,1),'-.b',T,C(:,2),'k','Linewidth',2); 
% %plot(T,C(:,2),'k','Linewidth',2); 
% %plot(T,Ca,'--r', T,Cf_n,'-.b',T,Cb_n,'k',T,Ce_n,':c','Linewidth',2);
% 
% plot(T,Ca,'--r', T,Cf_n,'-.b',T,Cb_n,'k','Linewidth',2); % Plot with noise
% %plot(T,Ca,'--r', T,C(:,1),'-.b',T,C(:,2),'k','Linewidth',2); % Plot without noise
% 
% xlabel('Time (min.)','FontSize',14,'FontName','Arial'); 
% ylabel('Radioactivity (arb. units)','FontSize',14,'FontName','Arial')
% % hleg1 = legend('Arterial Input', 'Free Tracer', 'Specific Binding', 'Endogenous DA'); 
% hleg1 = legend('Arterial Input', 'Free Tracer', 'Specific Binding'); 
% set(hleg1,'Location','Best','FontSize',12,'FontName','Arial'); 
% set(gcf,'color','w');
% title('Infusion (Striatum)','FontSize',16,'fontWeight','bold','FontName','Arial');

end

