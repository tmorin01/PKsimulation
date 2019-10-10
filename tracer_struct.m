% Written by: Tom Morin
% Date: June 2015
% Modified from properties.m by Hsiao-Ying Monica Wey
%
% Returns a structure of radiotracer data
%
function [ tracer ] = tracer_struct()
%%   Format of Struct:
%   tracer(idx).name -------------- name of the radiotracer
%
%   tracer(idx).ref  -------------- reference to literature
%
%   tracer(idx).ref_tissue -------- recommended reference tissue
%
%   tracer(idx).available_areas --- list of brain regions available for analysis 
%                                   with this tracer (Comma-separated cellstr)
%   tracer(idx).TwoTC.k.brain_area - k-values for a specific brain area in a 2
%                                   Tissue compartment model
%   tracer(idx).OneTC.k.brain_area - k-values for a specific brain area in
%                                     a 1 Tissue compartment model
%   tracer(idx).kp ----------------- kp values for a specific brain area in a 
%                                     2 Tissue compartment model
%   tracer(idx).kr ----------------- kr values for a specific brain area in
%                                     a 2 Tissue compartment model
%   tracer(idx).k_da --------------- k_da (endogenous Dopamine k-values)
%                                     for a 2-Tissue compartment model with competition
%   tracer(idx).bolus_curve -------- directory of the default TAC file for 
%                                     B/I input

%
% ========================= List of Tracers ============================= %
%
% Human:
% 1: RAC
% 2: DPN
% 3: fallypride
% 4: CFN
% 5: CB1: FMPEP-d2
% 6: FDG
%
% Nonhuman Primate:
% 7: kappa opioid: LY2795050
% 8: FAAH: FDOPP
% 9: HDACi: CN133
%
% ============================== Human ================================== %

% 1. Raclopride
tracer(1).name              = 'Raclopride';
tracer(1).ref               = 'Farde et al. 1989, JCBFM';
tracer(1).ref_tissue        = 'Cerebellum';
tracer(1).compounds         = {'C-11'};
tracer(1).available_areas   = {'General'};
tracer(1).TwoTC.k.general   = [0.15, 0.37, 0.60, 0.14];    % k3/k2 = 1.62; k1/k2 = 0.41;  k3/k4 = 4.28;
%tracer(1).TwoTC.k.other    = [0.1, 0.13, 0.05, 0.03];
tracer(1).OneTC.k.general   = [0 0];
tracer(1).kp                = NaN;
tracer(1).kr                = [0.15, 0.37];
tracer(1).k_da              = [13.5, 25];
tracer(1).bolus_curve       = 'Not Available';


% 2. Fallypride
tracer(2).name              = 'Fallypride';
tracer(2).ref               = 'Christian et al., 2004';
tracer(2).ref_tissue        = 'Cerebellum';
tracer(2).compounds         = {'F-18'};
tracer(2).available_areas   = {'General'; 'Striatum'; 'Frontal Lobe'};
tracer(2).TwoTC.k.striatum  = [0.17, 0.21, 2.16, 0.043];
tracer(2).TwoTC.k.frontal   = [0.21, 0.24, 0.066, 0.043];
tracer(2).OneTC.k.general   = [0 0];
tracer(2).kp                = [0.17, 0.21, 1.08, 0.043];
%tracer(2).TwoTC.kp         = [0.1 0.35 0.1 0.06];
tracer(2).kr                = [0.17, 0.21];
tracer(2).k_da              = [13.5, 25]; % endogenous DA with Kon = 54*0.25
tracer(2).bolus_curve       = 'Not Available';

        
% 3. Carfentanil
tracer(3).name              = 'Carfentanil';
tracer(3).ref               = 'Frost, 1989, JCBFM';
tracer(3).ref_tissue        = 'Occipital Cortex';
tracer(3).compounds         = {'C-11'};
tracer(3).available_areas   = {'General'; 'Thalamus'; 'Frontal Lobe'};
tracer(3).TwoTC.k.thalamus  = [0.107, 0.201, 0.201, 0.06];
tracer(3).TwoTC.k.frontal   = [0.108, 0.201, 0.382, 0.217];
tracer(3).OneTC.k.general   = [0 0];
tracer(3).kp                = NaN;
tracer(3).kr                = [0.4, 0.15];
tracer(3).k_da              = NaN;
tracer(3).bolus_curve       = 'Default_TACs/CFN_NHP.tac';


% 4. Diprenorphine
tracer(4).name              = 'Diprenorphine';
tracer(4).ref               = 'Jones, 1994, J. Neurosci Methods';
tracer(4).ref_tissue        = 'Occipital Cortex';
tracer(4).compounds         = {'C-11';'F-18'};
tracer(4).available_areas   = {'General','Thalamus','Striatum','Anterior Cortex','Posterior Cortex','Hippocampus','Medulla','Spinal Cord'};
tracer(4).TwoTC.k.general   = [0.4, 0.15, 0.4, 0.07];      % k3/k2 = 2.66; k1/k2 = 2.67;  k3/k4 = 5.71;
% Cunningham et al., 1991
tracer(4).TwoTC.k.thalamus  = [1.25, 0.247, 0.0155, 0.112];
tracer(4).TwoTC.k.striatum  = [1.13, 0.228, 0.0153, 0.124];
tracer(4).TwoTC.k.ant_cx    = [1.27, 0.313, 0.0173, 0.111];
tracer(4).TwoTC.k.post_cx   = [1.30, 0.308, 0.0226, 0.119];
tracer(4).TwoTC.k.hippocampus = [0.93, 0.198, 0.0275, 0.154];
tracer(4).TwoTC.k.medulla   = [1.15, 0.247, 0.0203, 0.120];
tracer(4).TwoTC.k.spinal_cord = [0.80, 0.209, 0.0184, 0.090];
tracer(4).OneTC.k.general   = [0 0];
tracer(4).kp                = [0.36, 0.19, 0.48, 0.08];
tracer(4).kr                = [0.4, 0.15];
tracer(4).k_da              = NaN;
tracer(4).bolus_curve       = 'Not Available';

% 5. FDG
tracer(5).name              = 'FDG';
tracer(5).ref               = 'No Reference Available';
tracer(5).ref_tissue        = '';
tracer(5).compounds         = {'F-18'};
tracer(5).available_areas   = {'General'};
tracer(5).TwoTC.k.general   = [0.1, 0.2, 0.11, 0.001];
tracer(5).OneTC.k.general   = [0 0];
tracer(5).kp                = [0.2, 0.3, 0.2, 0.01];
tracer(5).kr                = NaN;
tracer(5).k_da              = NaN;
tracer(5).bolus_curve       = 'Not Available';


% 6. FMPEP-d2
tracer(6).name              = 'FMPEP';
tracer(6).ref               = 'Terry, Innis, et al., 2010, JNM';
tracer(6).ref_tissue        = '';
tracer(6).compounds         = {'F-18'};
tracer(6).available_areas   = {'General'};
tracer(6).TwoTC.k.general   = [0.1, 0.06, 0.13, 0.02];
tracer(6).OneTC.k.general   = [0 0];
tracer(6).kp                = [0.08, 0.08, 0.18, 0.03]; % low
% tracer(6).kp              = [0.06, 0.1, 0.2, 0.03]; % high
tracer(6).kr                = NaN;
tracer(6).k_da              = NaN;
tracer(6).bolus_curve       = 'Not Available';


% ======================= Non-Human Primates ============================ %

% 7. Kappa Opioid: LY2795050 (NHP)
tracer(7).name              = 'LY2795050_NHP';
tracer(7).ref               = 'Kim, Morris, et al., 2013, JNM';
tracer(7).ref_tissue        = '';
tracer(7).compounds         = {'C-11'};
tracer(7).available_areas   = {'General'};
tracer(7).TwoTC.k.general   = [0.1, 0.06, 0.13, 0.02];
tracer(7).OneTC.k.general   = [0 0];
tracer(7).kp                = NaN;
tracer(7).kr                = NaN;
tracer(7).k_da              = NaN;
tracer(7).bolus_curve       = 'Default_TACs/LY279_NHP.tac';

% 8. FAAH: FDOPP (NHP)
tracer(8).name              = 'FDOPP_NHP';
tracer(8).ref               = 'Wey et al., 2013, JNM';
tracer(8).ref_tissue        = '';
tracer(8).compounds         = {'F-18'};
tracer(8).available_areas   = {'General'};
tracer(8).TwoTC.k.general   = [0.1, 0.06, 0.13, 0.02];
tracer(8).OneTC.k.general   = [0 0];
tracer(8).kp                = NaN;
tracer(8).kr                = NaN;
tracer(8).k_da              = NaN;
tracer(8).bolus_curve       = 'Not Available';

% 9. HDACi: CN133 (NHP)
tracer(9).name              = 'CN133_NHP';
tracer(9).ref               = 'Wey et al., 2014, ???';
tracer(9).ref_tissue        = '';
tracer(9).compounds         = {'C-11'};
tracer(9).available_areas   = {'General'};
tracer(9).TwoTC.k.general   = [0.71, 0.36, 0.21, 0.0104];
tracer(9).OneTC.k.general   = [0 0];
tracer(9).kp                = [0.6 0.4 0.26 0.02];  % 0.5 mg/kg estimates (CN133-02 blocking)
%tracer(9).kp               = [0.39 0.82 0.36 0.02];  % 0.5 mg/kg estimates (CN133-02 blocking)
tracer(9).kr                = NaN;
tracer(9).k_da              = NaN;
tracer(9).bolus_curve       = 'Not Available';

% 10. Custom
tracer(10).name             = 'Custom';
tracer(10).ref              = 'No Reference';
tracer(10).ref_tissue       = '';
tracer(10).compounds        = {'C-11';'F-18';'O-15'};
tracer(10).available_areas  = {'General'};
tracer(10).TwoTC.k.general  = [0 0 0 0];
tracer(10).OneTC.k.general  = [0 0];
tracer(10).kp               = [0 0 0 0];
tracer(10).kr               = [0 0];
tracer(10).k_da             = [0 0];
tracer(10).bolus_curve      = 'Not Available';

% 10. ADD NEW TRACER HERE
%tracer(10).name            = 'NEW TRACER NAME'             %String
%tracer(10).ref             = 'REFERENCE TO LITERATURE'     %String
%tracer(10).ref_tissue      = 'REFERENCE TISSUE'            %String
%tracer(10).compounds       = {'C-11'; 'F-18'};             %Cells
%tracer(10).available_areas = {'General'; 'Frontal Lobe';}  %Cells
%tracer(10).TwoTC.k.region  = [k-values, 2-Tissue Compartmental Model] %Array
%tracer(10).OneTC.k.region  = [k-values for 1-Tissue Compartmental Model]%Array
%tracer(10).kp              = [kp-values, 2-Tissue Compartmental Model]%Array
%tracer(10).kr              = [kr-values, 2-Tissue Compartmental Model]%Array
%tracer(10).k_da            = [k-values for endogenous NT] %Array
%tracer(10).bolus_curve     = 'Filepath to Default TAC Curve File for B/I'

% Name: PBR28
% Lit Ref: Zanotti-Fregonara et al. PLOS, 2011 (10.1371/journal.pone.0017056)
% Ref. Tissue: None
% Compounds: C-11
% Areas: General (Thalamus???)
% TwoTC:
% 1.96  1.64    0.80    0.91
% 1.18  0.71    0.46    0.68
% One TC:
% 0 0
% kp: NaN
% kr: NaN
% k_da: NaN
% bolus_curve: N/A
% Other Cool Paper: Rizzo et al. 2014 JCBFM "Kinetic modeling without
% accounting for the vasular component impairs the quantification ..."

end

