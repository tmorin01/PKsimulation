% NO LONGER USED BY PK SIM (7/1/15)

% Function to get information about a radiotracer
%
% Author: Tom Morin
% Date: June, 2015
% Based on "property.m" by Hsiao-Ying Monica Wey
%
%%
function tracer_props = get_properties( tracer )
%Retrieve k-values, reference tissue, & citation info for a radiotracer
%   INPUT: radiotracer
%   OUTPUT: tracer_props struct that contains k-values for a compartmental
%   model, reference tissue info, & citations to appropriate literature
% Define radiotracer's kinetic properties from literature
%
%% List of tracers:
%
% Human:
% 1.1: RAC
% 1.2: DPN
% 1.3: fallypride
% 1.4: CFN
% 1.5: CB1: FMPEP-d2
% 1.6: FDG

% Nonhuman Primate:
% 2.1: kappa opioid: LY2795050
% 2.2: FAAH: FDOPP
% 2.3: HDACi: CN133

%% 1 - Human

switch tracer
    case 'Raclopride' 
        % 1. Raclopride
        tracer_props.ref = 'Farde et al. 1989, JCBFM';
        tracer_props.name = 'Raclopride';
        tracer_props.k = [0.15, 0.37, 0.60, 0.14];    % k3/k2 = 1.62; k1/k2 = 0.41;  k3/k4 = 4.28;
        %tracer(1).k = [0.1, 0.13, 0.05, 0.03];
        tracer_props.ref_tissue = 'Cerebellum';
        tracer_props.kr = [0.15, 0.37];
        tracer_props.kp = NaN;
        tracer_props.k_da = NaN;

    case 'Diprenorphine'
        % 2. Diprenorphine
        tracer_props.ref = 'Jones, 1994, J. Neurosci Methods';
        tracer_props.name = 'Diprenorphine';
        tracer_props.k = [0.4, 0.15, 0.4, 0.07];       % k3/k2 = 2.66; k1/k2 = 2.67;  k3/k4 = 5.71;
        tracer_props.ref_tissue = 'Occipital Cortex';
        tracer_props.kr = [0.4, 0.15];
        tracer_props.kp = [0.36, 0.19, 0.48, 0.08];
        tracer_props.k_da = NaN;
        
    case 'Fallypride'
        % 3. Fallypride
        tracer_props.ref = 'Christian et al., 2004';
        tracer_props.name = 'Fallypride';
        tracer_props.k = [0.17, 0.21, 2.16, 0.043];    % k3 = Bmax*kon = 54*0.04; % Striatum  % k3/k2 = 0.195; k1/k2 = 0.81;  k3/k4 = 1;
        %tracer(3).k = [0.21, 0.24, 0.066, 0.043];    % Frontal
        tracer_props.ref_tissue = 'Cerebellum';
        tracer_props.kr = [0.17, 0.21];
        %tracer(3).kp = [0.1 0.35 0.1 0.06];
        tracer_props.kp = [0.17, 0.21, 1.08, 0.043];
        tracer_props.k_da = [13.5, 25]; % endogenous DA with Kon = 54*0.25

    case 'Carfentanil'
        % 4. Carfentanil
        tracer_props.ref = 'Frost, 1989, JCBFM';
        tracer_props.name = 'Carfentanil';
        tracer_props.k = [0.107, 0.201, 0.201, 0.06];    % Thalamus  % k3/k2 = 1; k1/k2 = 0.53;  k3/k4 = 3.35;
        % tracer(4).k = [0.108, 0.201, 0.382, 0.217];    % frontal
        tracer_props.ref_tissue = 'Occipital Cortex';
        tracer_props.kr = [0.4, 0.15];
        tracer_props.kp = NaN;
        tracer_props.k_da = NaN;

    case 'CB1: FMPEP-d2'
        % 5. CB1: FMPEP-d2
        tracer_props.ref = 'Terry, Innis, et al., 2010, JNM';
        tracer_props.name = 'FMPEP-d2';
        tracer_props.k = [0.1, 0.06, 0.13, 0.02];
        tracer_props.ref_tissue = '';
        % tracer(5).kp = [0.06, 0.1, 0.2, 0.03]; % high
        tracer_props.kp = [0.08, 0.08, 0.18, 0.03]; % low
        tracer_props.kr = NaN;
        tracer_props.k_da = NaN;

    case 'FDG'
        % 6. FDG
        tracer_props.ref = 'No Reference Available';
        tracer_props.name = 'FDG';
        tracer_props.k = [0.1, 0.2, 0.11, 0.001];
        tracer_props.ref_tissue = '';
        tracer_props.kp = [0.2 0.3 0.2 0.01];
        tracer_props.kr = NaN;
        tracer_props.k_da = NaN;

% 2 - Nonhuman Primates
% 
% Almost ready to test ...
% 
    case 'K-Opioid: LY2795050 (NHP)'
        % 6. kappa opioid: LY2795050 (NHP)
        tracer_props.ref = 'Kim, Morris, et al., 2013, JNM';
        tracer_props.name = 'LY2795050';
        tracer_props.k = [0.1, 0.06, 0.13, 0.02];
        tracer_props.ref_tissue = '';
        tracer_props.kp = NaN;
        tracer_props.kr = NaN;
        tracer_props.k_da = NaN;

    case 'FAAH: FDOPP (NHP)'
        % 7. FAAH: FDOPP (NHP)
        tracer_props.ref = 'Wey et al., 2013, JNM';
        tracer_props.name = 'FDOPP';
        tracer_props.k = [0.1, 0.06, 0.13, 0.02];
        tracer_props.ref_tissue = '';
        tracer_props.kp = NaN;
        tracer_props.kr = NaN;
        tracer_props.k_da = NaN;

    case 'HDACi: CN133 (NHP)'
        % 8. HDACi: CN133 (NHP)
        tracer_props.ref = 'Wey et al., 2014, ???';
        tracer_props.name = 'CN133';
        tracer_props.k = [0.71, 0.36, 0.21, 0.0104];
        tracer_props.ref_tissue = '';
        %tracer(13).kp = [0.39 0.82 0.36 0.02];  % 0.5 mg/kg estimates (CN133-02 blocking)
        tracer_props.kp = [0.6 0.4 0.26 0.02];  % 0.5 mg/kg estimates (CN133-02 blocking)
        tracer_props.kr = NaN;
        tracer_props.k_da = NaN;
end
end

