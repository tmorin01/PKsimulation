% Define radiotracer's kinetic properties from literature
%
% Author: Hsiao-Ying Monica Wey
% Date: Aug 2013
% 
%% List of tracers:
%
% Human:
% 1: RAC
% 2: DPN
% 3: fallypride
% 4: CFN
% 5: CB1: FMPEP-d2

% Nonhuman Primate:
% 6: kappa opioid: LY2795050


%% Tacers

%% Human

% 1. Raclopride
% ref: Farde et al. 1989, JCBFM
tracer(1).name = 'Raclopride';
tracer(1).k = [0.15, 0.37, 0.60, 0.14];    % k3/k2 = 1.62; k1/k2 = 0.41;  k3/k4 = 4.28;
%tracer(1).k = [0.1, 0.13, 0.05, 0.03];
% cerebellum as reference tissue
% ref: 
tracer(1).kr = [0.15, 0.37];


% 2. Diprenorphine
% ref: Jones, 1994, J. Neurosci Methods
tracer(2).name = 'Diprenorphine';
tracer(2).k = [0.4, 0.15, 0.4, 0.07];       % k3/k2 = 2.66; k1/k2 = 2.67;  k3/k4 = 5.71;
% occipital cortex as reference tissue
% ref: 
tracer(2).kr = [0.4, 0.15];
tracer(2).kp = [0.36, 0.19, 0.48, 0.08];  

% 3. Fallypride
% ref: Christian et al., 2004
tracer(3).name = 'Fallypride';
tracer(3).k = [0.17, 0.21, 2.16, 0.043];    % k3 = Bmax*kon = 54*0.04; % Stratum  % k3/k2 = 0.195; k1/k2 = 0.81;  k3/k4 = 1;
%tracer(3).k = [0.21, 0.24, 0.066, 0.043];    % Frontal
% cerebellum as reference tissue
% ref: 
tracer(3).kr = [0.17, 0.21];
%tracer(3).kp = [0.1 0.35 0.1 0.06];
tracer(3).kp = [0.17, 0.21, 1.08, 0.043];
tracer(3).k_da = [13.5, 25]; % endogenous DA with Kon = 54*0.25

% 4. Carfentanil
% ref: Frost, 1989, JCBFM
tracer(4).name = 'Carfentanil';
tracer(4).k = [0.107, 0.201, 0.201, 0.06];    % Thalamus  % k3/k2 = 1; k1/k2 = 0.53;  k3/k4 = 3.35;
% tracer(4).k = [0.108, 0.201, 0.382, 0.217];    % frontal 
% occipital cortex as reference tissue
% ref: 
tracer(4).kr = [0.4, 0.15];


% 5. CB1: FMPEP-d2
% ref: Terry, Innis, et al., 2010, JNM
tracer(5).name = 'FEPEP-d2';
tracer(5).k = [0.1, 0.06, 0.13, 0.02];
% tracer(5).kp = [0.06, 0.1, 0.2, 0.03]; % high
tracer(5).kp = [0.08, 0.08, 0.18, 0.03]; % low

% 5. FDG
% ref: 
tracer(6).name = 'FDF';
tracer(6).k = [0.1, 0.2, 0.11, 0.001];
tracer(6).kp = [0.2 0.3 0.2 0.01];


%%

% %% Nonhuman Primates
% 
% %% Almost ready to test ...
% 
% % 6. kappa opioid: LY2795050 (NHP)
% % ref: Kim, Morris, et al., 2013, JNM
% tracer(11).name = 'LY2795050';
% tracer(11).k = [0.1, 0.06, 0.13, 0.02];
% 
% 
% % 7. FAAH: FDOPP (NHP)
% % ref: Wey et al., 2013, JNM
% tracer(12).name = 'FDOPP';
% tracer(12).k = [0.1, 0.06, 0.13, 0.02];
% 
% 
% 8. HDACi: CN133 (NHP)
% ref: Wey et al., 2014, ???
tracer(13).name = 'CN133';
tracer(13).k = [0.71, 0.36, 0.21, 0.0104];
%tracer(13).kp = [0.39 0.82 0.36 0.02];  % 0.5 mg/kg estimates (CN133-02 blocking)
tracer(13).kp = [0.6 0.4 0.26 0.02];  % 0.5 mg/kg estimates (CN133-02 blocking)

