function Ca = InputFunc(t)

% 
% t = 0:0.5:90;                            % Time in min.
tlen = length(t); 

%% Bolus

Ca = GeneralFengInput([1,85.11,2.188,2.081,-4.134,-0.1191,-0.01043], t);

% % Bolus (Normandin et al. 2008)
% b = [12; 1.8; 0.45];                    % [nM/min; nM; nM]
% kap = [4; 0.5; 0.008];                  % [1/min; 1/min; 1/min]
% Ca = (b(1).*t - b(2) - b(3)).*exp(-kap(1).*t) + b(2).*exp(-kap(2).*t) + b(3).*exp(-kap(3).*t); 


% Infusion
% 
% % Constant
% % r = 3;                              % Infusion rate
% r=0.6;
% Ca = r.*ones(1,tlen); 

% % Bolus + infusion
% 
% t1 = 0:0.5:3;
% % % Ca1 = GeneralFengInput([1,85.11,2.188,2.081,-4.134,-0.1191,-0.01043], t1);
% % (Normandin et al. 2008)
% b = [12; 1.8; 0.45];                    % [nM/min; nM; nM]
% kap = [4; 0.5; 0.008];                  % [1/min; 1/min; 1/min]
% Ca1 = (b(1).*t1 - b(2) - b(3)).*exp(-kap(1).*t1) + b(2).*exp(-kap(2).*t1) + b(3).*exp(-kap(3).*t1); 
% 
% r = 0.6;                              % Infusion rate
% Ca2 = r.*ones(1,tlen); 
% 
% Ca = zeros(1,tlen);
% Ca(1,1:length(t1)) = Ca1;
% Ca(1,length(t1)+1:tlen) = Ca2(1,length(t1)+1:tlen);
% 
% 
% % Gradual infusion
% r = 8 - 0.05*t;             % fast: 8-0.08*t; slow: 8-0.05*t
% Ca = r.*ones(1,tlen);

% % sigmoidal
% Ca = exp(-0.1*t)+exp(-0.01*t);
% 
% % inverted gamma
% Ca = 1./gamma(t);

end

