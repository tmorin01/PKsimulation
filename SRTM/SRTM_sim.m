% SRTM_sim.m
% Author: Tom Morin
% Date: August, 2015
%
% Purpose: Use the TAC curves for Reference Region and Region of
% Interest to calculate dynamic Binding Potential.  Methods based on those
% developed by Joe B. Manderville at http://www.nmr.mgh.harvard.edu/~jbm/jip/jip-srtm/
% (Athinoula A. Martinos Center for Biomedical Imaging at MGH/MIT/Harvard)
%

function plot_data = SRTM_sim(roi_tac, reference_tac, handles, chal_times, amplitude, noise)

%% Run the SRTM (Calculate Binding Potential)
t = [0:0.5:roi_tac(1,end)];

% Set up matrices for system of linear equations
Ct(1,:) = roi_tac(2,:);
Cr(1,:) = reference_tac(2,:);

% Integrate Ct
iCt = zeros(1,length(Ct));
for m=1:length(Ct)
    if m==1
        iCt(1,1) = Ct(1,1);
    else
        iCt(1,m) = 0.5.*Ct(1,m) + iCt(1,m-1);
    end
end

% Integrate Cr
iCr = zeros(1,length(Cr));
for m=1:length(Cr)
    if m==1
        iCr(1,1) = Cr(1,1);
    else
        iCr(1,m) = 0.5.*Cr(1,m) + iCr(1,m-1);
    end
end


% *********** NOT SURE ABOUT THIS..... **************
% Solve for parameters R1, k2, and k2a using matrices
% X = Ct * [Cr; iCr; iCt]';
% assignin('base','X',X);

% *********** LEANING TOWARDS THIS ONE!!!!..... **************
% Solve for parameters R1, k2, and k2a using Matrix Left Division
M_unfixed = cat(2,Cr',iCr',iCt');
Z_unfixed = mldivide(M_unfixed,Ct');
R1 = Z_unfixed(1);
k2 = Z_unfixed(2);
k2a = -1 .* Z_unfixed(3);

% assignin('base','M_unfixed',M_unfixed);
% assignin('base','Ct_matrix',Ct);
% assignin('base','Z_unfixed',Z_unfixed);

% Fix k2_prime & solve for R1 & k2a again
k2_prime = k2/R1;
fixed_term = Cr + (k2_prime .* iCr);
M_fixed = cat(2, fixed_term', iCt');
%assignin('base','M_fixed', M_fixed);
Z_fixed = mldivide(M_fixed,Ct');
%assignin('base','Z_fixed',Z_fixed);
R1 = Z_fixed(1);
k2a = -1 .* Z_fixed(2);

% Assign Fitted Parameters to base for later examination
assignin('base','R1',R1);
assignin('base','k2a',k2a);
assignin('base','k2',k2);

% *********** NOT SURE ABOUT THIS..... **************
% A = Ct';
% B = [Cr; iCr; iCt]';
% Y = glmfit(B,A);
% R1 = Y(2);
% k2 = Y(3);
% k2a = Y(4) .* -1;
% assignin('base','Y',Y);

% Calculate Binding Potential
BP = zeros(1,length(Ct));
BP(1,:) = (k2/k2a) - 1;
assignin('base','BP',BP);

% Generate a gamma curve
tao = 50;
challenge_curve = generate_gamma(roi_tac(1,:),chal_times,tao,amplitude);
%igamma = integration(Ct.*gamma);
%original_Ct = Ct;
%assignin('base','Ct',Ct);
BP = BP - (k2a .* challenge_curve);
%Ct = Ct - (k2a .* challenge_curve);
%assignin('base','Ct_minus_gamma',Ct);


% figure;
% hold on;
% plot(original_Ct);
% plot(Ct);


% ******************** PLOT **********************
plot_data.x(1,:) = t;
plot_data.y(1,:) = noiseModel(t,roi_tac(2,:),handles,noise);
plot_data.x(2,:) = t;
plot_data.y(2,:) = noiseModel(t,Ct,handles,noise);
plot_data.x(3,:) = t;
plot_data.y(3,:) = noiseModel(t,reference_tac(2,:),handles,noise);

plot_data.x(4,:) = t;
plot_data.y(4,:) = BP;

%% Get Competition Info from main GUI & create endogenous NT pulse
% If Endogenous Dopamine is selected, generate an endogenous input curve
t = roi_tac(1,:);
tlen = length(roi_tac)/2;

if ~isnan(chal_times)
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

% Adjust for challenges
plot_data.y(2,:) = plot_data.y(2,:) - (0.00025 .* plot_data.NT);
plot_data.y(3,:) = plot_data.y(3,:) + (0.00025 .* plot_data.NT);

% Display fitted parameters in a new figure
set(figure,'Position',[50 500 290 450]); 
annotation('textbox',...
    [0.05 0.8 0.1 0.1],...
    'String',{'SRTM Fitted Parameters:','','R =',R1,'','k_2 =',k2,'','k_2_a =',k2a,'','k_2^, =',k2_prime,'','BP =',BP(1,1)},...
    'FontSize',20,...
    'EdgeColor',[0.0784313753247261 0.168627455830574 0.549019634723663],...
    'BackgroundColor',[1 1 1],...
    'FitBoxToText','on');

assignin('base','SRTM_time',t');
assignin('base','SRTM_ROI',roi_tac(2,:)');
assignin('base','SRTM_REF',reference_tac(2,:)');

% plot_data.NT(1,:) = zeros(1,length(plot_data.x(1,:)));
% 
% %% Assign data for plotting
% 
% plot_data.x(1,:) = roi_tac(1,:);
% plot_data.y(1,:) = noiseModel(t,roi_tac(2,:),handles,noise);
% plot_data.x(2,:) = reference_tac(1,:);
% plot_data.y(2,:) = noiseModel(t,reference_tac(2,:),handles,noise);
% % plot_data.x(3,:) = roi_tac(1,:);
% % plot_data.y(3,:) = BP(1,:);
% plot_data.x(3,:) = BP(1,:);
% plot_data.y(3,:) = noiseModel(t,BP(2,:),handles,noise);
% 
% plot_data.x(4,:) = Ct(1,:);
% plot_data.y(4,:) = noiseModel(t,Ct(2,:),handles,noise);
% 
% end
