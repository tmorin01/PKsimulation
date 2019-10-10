% test_kbol_optimization.m
%
% Author: Tom Morin
% Date: July, 2015
% Purpose: Create a bolus plus continuous infusion AIF according to user
% specified parameters including Kbol (and possibly including a rate of
% infusion).

function Cp = test_kbol_optimization(handles,Kbol,t,bolus_tac)
% Sources consulted for the Bolus plus continuous infusion simulation:

%% ATTEMPT # 1: Bolus as convolved curve
% Houle, S, et al. Measurement of 11C Raclopride Binding Using a Bolus plus
% Infusion Protocal (Probably Around 1995).... Published in "Quantification
% of Brain Function Using PET"

% Watabe, H, et al. Measurement of Dopamine Release with Continuous
% Infusion of 11C Raclopride: Optimization and Signal:Noise Considerations
% (March, 2000)

% Carson et al., Comparison of Bolus and Infusion Methdos for Receptor 
% Quantitation: Application to 18F Cyclofloxy and Positron Emission
% Tomography (1993)

% % Get a default bolus curve
% b = [12; 1.8; 0.45];                    % [nM/min; nM; nM]
% kap = [4; 0.5; 0.008];                  % [1/min; 1/min; 1/min]
% Ca = (b(1).*t - b(2) - b(3)).*exp(-kap(1).*t) + b(2).*exp(-kap(2).*t) + b(3).*exp(-kap(3).*t);
% % assignin('base','Ca',Ca);
% 
% %Q = trapz(t,Ca); % Q = ammount of bolus injection
% Q = 450;
% R = 4;
% % assignin('base','Q',Q);
% % assignin('base','Kbol',Kbol);
% 
% T = t(end); % Time @ which infusion ends
% 
% % Set decay constant depending on the radioactive molecule being used
% lambda = 0;
% if strcmp(get(handles.active_comp,'String'),'C-11')
%     lambda = 20.33; % decay constant for carbon-11
% elseif strcmp(get(handles.active_comp,'String'),'F-18')
%     lambda = 110;
% end
% 
% A = Q + (R/lambda)*(1-exp(-lambda*T)); % A = total amount of radioligand injected
% assignin('base','A',A);
% 
% % Convolve the default bolus curve with the bolus plus infusion input
% temp = conv(Ca,((Q.*kroneckerDelta(t)+R.*heaveside(t))./A));
% assignin('base','convolved',temp);
% Cp = temp(1:length(t));
% Cp = Q.*(kroneckerDelta(t)+R.*heaveside(t))./A;


%% ATTEMPT #2: Bolus as triangle
% R = 0.6;
% infusion_rate = R;
% Cp = zeros(size(t));
% bolus_ammount = Kbol .* infusion_rate;
% bolus_height = bolus_ammount;
% Cp(1,1) = bolus_height;
% Cp(1,2) = bolus_height.*0.75;
% Cp(1,3) = bolus_height.*0.5;
% Cp(1,3) = bolus_height.*0.25;
% for m=4:length(Cp)
%     Cp(1,m) = infusion_rate;
% end

%% ATTEMPT #3: Pg. 97 of PK Guide

T = t(end); % end time

Cp = ((Kbol./(Kbol+T)).*bolus_tac) + ((T./(Kbol+T)).*(1/T.*trapz(t,bolus_tac)));

end