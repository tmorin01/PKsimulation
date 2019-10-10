%% OLD CODE NO LONGER USED

function plot_data = SRTM_sim(roi_tac, reference_tac, handles, chal_times, amplitude, noise)

%% Run the SRTM (Calculate Binding Potential)
% Set up matrices for system of linear equations
C_roi = roi_tac(2,:)';
C_ref = reference_tac(2,:)';
dC_roi = diff(C_roi);
dC_ref = diff(C_ref);

% Integrate ROI
iC_roi = zeros(length(C_roi),1);
for m=1:length(C_roi)
    if m==1
        iC_roi(1,1) = C_roi(1,1);
    else
        iC_roi(m,1) = 0.5.*C_roi(m,1) + iC_roi(m-1,1);
    end
end

% Integrate Ref
iC_ref = zeros(length(C_ref),1);
for m=1:length(C_ref)
    if m==1
        iC_ref(1,1) = C_ref(1,1);
    else
        iC_ref(m,1) = 0.5.*C_ref(m,1) + iC_ref(m-1,1);
    end
end     

% Solve for parameters R1, k2, and k2a = (k2/(1+BP)) using a Generalized
% Linear Model fit
C = C_roi;
D = cat(2, C_ref, iC_ref, iC_roi);
Y = glmfit(D,C);
Y(4) = -1.*Y(4);
assignin('base','Y',Y); 
% Soln matrix Y:
% Y(1) = meaningless number
% Y(2) = R
% Y(3) = k2
% Y(4) = k2a

% Fit & fix k2'
BP(1) = Y(3)./(Y(4)) - 1;
k2_prime = (Y(4).*(1 + BP(1)))./Y(2);
assignin('base','k2_prime',k2_prime);

% Get gamma term for challenge plot
assignin('base','C_roi',C_roi);
assignin('base','chal_times',chal_times);

if ~isnan(chal_times)
    for m=1:length(chal_times)
        if m==1
%             first = C_roi(1:chal_times(m)*2-1,1);
            start = chal_times(m)*2;
            time = roi_tac(1,:);
            time(1,start:start+3) = time(1,start:start+3) + (amplitude(m)/1000).*gamma([10 20 30 40]);
            %first = roi_tac(1,1:chal_times(m)*2-1);
            %second = (amplitude(m)/1000).*gamma([10 20 30]);
%             second = (amplitude(m)/1000).*gamma(C_roi(chal_times(m)*2:end,1));
            gamma_term = cat(2,first,second);
            assignin('base','first',first);
            assignin('base','second',second);
            assignin('base','gamma_term_1',gamma_term);
            assignin('base','roi_tac',roi_tac);
        else
%             first = gamma_term(1:chal_times(m)*2-1,1);
%             assignin('base','first',first);
%             second = (amplitude(m)/1000).*gamma(gamma_term(chal_times(m)*2:end,1)) + gamma_term(chal_times(m)*2:end,1);
%             assignin('base','second',second);
%             gamma_term = cat(1,first,second);
        end
    end
%     % Integrate gamma term
%     igamma_term = zeros(length(C_ref),1);
%     for m=1:length(C_ref)
%         if m==1
%             igamma_term(1,1) = gamma_term(1,1);
%         else
%             igamma_term(m,1) = 0.5.*gamma_term(m,1) + igamma_term(m-1,1);
%         end
%     end
    gamma_term = gamma_term .* C_roi;
    term1 = ((Y(2).*(C_ref + k2_prime.*(iC_ref))) - (0.05.*iC_roi));
    Ct(1,:) = roi_tac(1,:);
    Ct(2,:) = (term1) - (Y(4).*gamma_term);
    assignin('base','Ct',Ct);
    assignin('base','term1',term1);
    assignin('base','gamma_term', gamma_term);
    k2a_gamma = ((-1).*(Ct(2,:)' - term1))./gamma_term;
    assignin('base','k2a_gamma',k2a_gamma);
else
    gamma_term = zeros(length(C_roi),1);
    term1 = ((Y(2).*(C_ref + k2_prime.*(iC_ref))) - (Y(4).*iC_roi));
    Ct(1,:) = roi_tac(1,:);
    Ct(2,:) = (term1) - (Y(4).*gamma_term);
end
assignin('base','gamma_term_2',gamma_term);

% % Calculate new binding potentials after each challenge
% % Z(2) = R1
% % Z(3) = k2a
% % Z(4) = k2a_gamma
% Z = zeros(0,0);
% if ~isnan(chal_times)
%     for m=1:length(chal_times)
%         if m == length(chal_times)
%             disp('ending');
%             start = chal_times(m)*2;
%             tem = Ct';
%             A = tem(start:end,2);
%             B = cat(2,(C_ref(start:end,1) + k2_prime.*(iC_ref(start:end,1))), iC_roi(start:end,1), gamma_term(start:end));
%             assignin('base','A',A);
%             assignin('base','B',B);
%             Z = glmfit(B,A);
%             Z(3) = -1.*Z(3);
%             Z(4) = -1.*Z(4);
%             BP(m+1) = ((Z(2)*k2_prime)./Z(3)) - 1;
%             assignin('base','Z2',Z);
%         else
%             disp(['at challenge: ' m]);
%             start = chal_times(m)*2;
%             fin = chal_times(m+1)*2-1;
%             tem = Ct';
%             A = tem(start:fin,2);
%             B = cat(2,(C_ref(start:fin,1) + k2_prime.*(iC_ref(start:fin,1))), iC_roi(start:fin,1), gamma_term(start:fin));
%             Z = glmfit(B,A);
%             Z(3) = -1.*Z(3);
%             Z(4) = -1.*Z(4);
%             BP(m+1) = ((Z(2)*k2_prime)./Z(3)) - 1;
%             assignin('base','Z1',Z);
%         end
%     end
% end

% assignin('base','Z',Z);
% assignin('base','BP',BP);

% Plot of difference between dynamic tissue curve & reference region
Bound(1,:) = Ct(1,:);
Bound(2,:) = Ct(2,:) - reference_tac(2,:);


% ******************** NO LONGER USED 7/23 ********************
%C_roi(end,:) = [];
%C_ref(end,:) = [];

% % Solution via derived thing
% A = dC_roi;
% B = cat(2, dC_ref, C_ref, C_roi);
% 
% % Solve for the unknown parameters
% % X(1) = R1
% % X(2) = k2
% % X(3) = (k2/(1+BP)) = k2a
% %X = linsolve(A,B);
% X = glmfit(B,A);
% assignin('base','X',X);
% *************************************************************



%% Get Competition Info from main GUI & create endogenous NT pulse
% If Endogenous Dopamine is selected, generate an endogenous input curve
t = roi_tac(1,:);
tlen = length(roi_tac)/2;

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
% plot_data.NT(1,:) = zeros(1,length(plot_data.x(1,:)));

%% Assign data for plotting

plot_data.x(1,:) = roi_tac(1,:);
plot_data.y(1,:) = noiseModel(t,roi_tac(2,:),handles,noise);
plot_data.x(2,:) = reference_tac(1,:);
plot_data.y(2,:) = noiseModel(t,reference_tac(2,:),handles,noise);
% plot_data.x(3,:) = roi_tac(1,:);
% plot_data.y(3,:) = BP(1,:);
plot_data.x(3,:) = Bound(1,:);
plot_data.y(3,:) = noiseModel(t,Bound(2,:),handles,noise);

plot_data.x(4,:) = Ct(1,:);
plot_data.y(4,:) = noiseModel(t,Ct(2,:),handles,noise);

end