% Determine the shape of the Arterial Input Function (AIF) according to
% user preferences
%
% Author: Tom Morin
% Date: June, 2015
% Based on "InputFunc.m" by Hsiao-Ying Monica Wey
%
%%
function Ca = get_InputFunc(handles,method, t)
%Determine the input function according to user preferences
%   INPUT: 
%       method: a string: Bolus, Bolus Infusion, etc.
%       t:      time
%   OUTPUT: the mathematical function for that input

%t = 0:0.5:90;                            % Time in min.
tlen = length(t);

switch method
    case 'Select an Input Function'
        warndlg('Select and Input Function');
        
    case 'General Feng'
        % General Feng Input
        ref = 'Reference Unavailable';
        Ca = GeneralFengInput([1,85.11,2.188,2.081,-4.134,-0.1191,-0.01043], t);
        
    case 'Bolus'
        % Bolus
        ref = 'Bolus (Normandin et al. 2008)';
        b = [12; 1.8; 0.45];                    % [nM/min; nM; nM]
        kap = [4; 0.5; 0.008];                  % [1/min; 1/min; 1/min]
        Ca = (b(1).*t - b(2) - b(3)).*exp(-kap(1).*t) + b(2).*exp(-kap(2).*t) + b(3).*exp(-kap(3).*t);
        %assignin('base','Ca',Ca);

    case 'Infusion'
        % Infusion
        % Constant
        % r = 3;                              % Infusion rate
        ref = 'Reference Unavailable';
%         r=0.2;
%         Ca = r.*ones(1,tlen);
        a = 10.44;
        b = -0.001056;
        c = -9.508;
        d = -0.03811;
        
        Ca = (a.*exp(b.*t) + c.*exp(d.*t))./10;


    case 'Bolus & Infusion'
        global tissue_tac Kbol num_kbol;
        % Bolus + infusion

        if tissue_tac(1,1) ~= -1
            % Get TAC for target tissue
            target_tac = pchip(tissue_tac(1,:),tissue_tac(2,:),t);
            
            % Integrate the TAC (via Reimann Sum)
            integrated_target = zeros(1,length(target_tac));
            for m=1:length(target_tac)
                if m == 1
                    integrated_target(1,m) = target_tac(1,m);
                else
                    integrated_target(1,m) = (target_tac(1,m) * (t(m) - t(m-1))) + integrated_target(1,m-1);
                end
            end
            
            % Get the scan duration
            duration = str2num(get(handles.time,'String'));
            
            % Calculate B/I model for each value of Kbol
            Ca = zeros(num_kbol,length(target_tac));
            for m=1:num_kbol
                dose_b = (Kbol(m) / (Kbol(m) + duration));
                dose_i = 1 - dose_b;
                Ca(m,:) = (dose_b.*target_tac) + (dose_i.*((1./duration).*integrated_target));
            end
        else
            disp('SIMULATING INPUT CURVE');
        end
   
    case 'Gradual Infusion'
        % Gradual infusion
        ref = 'Reference Unavailable';
        r = 8 - 0.05*t;             % fast: 8-0.08*t; slow: 8-0.05*t
        Ca = r.*ones(1,tlen);

    case 'Sigmoidal'
        % sigmoidal
        ref = 'Reference Unavailable';
        Ca = exp(-0.1*t)+exp(-0.01*t);

    case 'Inverted Gamma'
        % inverted gamma
        ref = 'Reference Unavailable';
        Ca = 1./gamma(t);
        
    case 'Sine Wave'
        % sine wave
        ref = 'Math';
        Ca = abs(sin(100.*t));
        
    case 'Custom'
        global custom_input;
        ref = 'Custom Input Function';
        Ca = zeros(1,tlen);
        for m=1:tlen
            for n=1:length(custom_input)
                if custom_input(n,1) <= t(1,m)
                    Ca(1,m) = custom_input(n,2);
                else
                    break;
                end
            end
        end
        assignin('base','Ca',Ca);
        
    otherwise
        disp(method)
        disp('Not Found.');
end

assignin('base','Ca',Ca);
end

