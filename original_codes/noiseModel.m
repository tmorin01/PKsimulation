% noiseModel.m
% Original Author: Hsiao-Ying (Monica) Wey
% Modified By: Tom Morin
% Date Modified: August 5, 2015
% Purpose of Modification: Add Poisson Noise & Random Noise

function Cn = noiseModel(t,C,handles,noise)

contents = cellstr(get(handles.noise_type,'String'));
noise_type = contents{get(handles.noise_type,'Value')};

Sc = noise;    % Logan, 2003: Sc = 0.25 ~ 8;
tf = 1;   % time frame (min)
tlen = length(t);

% Adjust noise based on the type of radiotracer
contents = cellstr(get(handles.active_comp,'String'));
isotope = contents{get(handles.active_comp,'Value')};
if strcmp(isotope,'C-11')
    T_half = 20.4;
elseif strcmp(isotope, 'F-18')
    T_half = 110;
elseif strcmp(isotope, 'O-15')
    T_half = 2;
end

lamda = log(2)/T_half;

%%
% Random Noise 
% Old Reference that is no longer used: (ref: Logan, JCBFM, 2003)
if strncmp(noise_type,'Random',6)
    xx = zeros(1,tlen);
    for i = 1:tlen
        xx(i) = randi(100); % Choose Random noise factor
        xx(i) = xx(i)./100;
        sign = randi(2); % Decide if positive or negative
        if sign == 1
            xx(i) = -1 .* xx(i);
        end
    end
    dev = xx.*Sc.*((exp(-lamda.*t).*C./tf)).^0.5;
    
    Cn = C + exp(lamda.*t).*dev;
    
% gaussian distribusion with mean = 0, variance = 1;
elseif strncmp(noise_type,'Gaussian',8)
    MU = zeros(1,1);
    SIGMA = ones(1,1);
    P = ones(1,1);
    obj = gmdistribution(MU,SIGMA,P);
    
    xx = zeros(1,tlen);
    for i = 1:tlen;
        xx(i) = random(obj);
    end
    
    dev = xx.*Sc.*((exp(-lamda.*t).*C./tf)).^0.5;
    
    Cn = C + exp(lamda.*t).*dev;

% Poisson Noise
elseif strncmp(noise_type,'Poisson',7)
    %obj = poisspdf(t,lamda);
    
    xx = zeros(1,tlen);
    for i = 1:tlen
        xx(i) = poissrnd(lamda); % Choose random poisson number
        sign = randi(2); % Decide if positive or negative
        if sign == 1
            xx(i) = -1 .* xx(i);
        end
    end
    dev = xx.*Sc.*((exp(-lamda.*t).*C./tf)).^0.5;
    
    Cn = C + exp(lamda.*t).*dev;
    
end