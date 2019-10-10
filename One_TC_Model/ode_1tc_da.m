% ode_1tc_da.m
% 
% Author: Tom Morin
% Based on: Hsiao-Ying (Monica) Wey's ode_2tc_da.m
% Date: June 2015
%
% Purpose: Present differential equations that describe a 1-Tissue
% Compartment Model with the option of an endogenous challenge.  These
% equations are used to produce a solution with built-in solver ode23s.m

function dc = ode_1tc_da(t,c,tCa,Ca,t_EN,NT)

%global k
global k k_da kp
Bmax = 54;

Ca = interp1(tCa,Ca,t);

NT = interp1(t_EN,NT,t);


% Differential equations
% c(1): Tissue, c(2): Tissue_EN
% 
% dc = zeros(1,1);        % a column vector
% dc(1) = k(1)*Ca - k(2)*c(1)
% dc(1) = k(1)*Ca - (k(2)+k(3))*c(1) + k(4)*c(2);   
% dc(2) = k(3) *c(1) - k(4)*c(2); 


% Within scan challenge, assuming k' (kp) values
if ~isnan(k_da)
    dc = zeros(2,1);
    dc(1) = -k(2)*c(1) + k(1)*Ca - k(1)*(Bmax-c(1)-c(2));
    dc(2) = k_da(1)*(Bmax-c(1)-c(2))*NT - k_da(2)*c(2);
    %dc(2) = k_da(1)*(Bmax-c(1)-c(2))*NT - k_da(2)*c(2);
    
elseif ~isnan(k)
    dc = zeros(2,1);
    dc(1) = -k(2)*c(1) + k(1)*Ca;
    dc(2) = 0;
    
elseif ~isnan(kp)
    dc = zeros(2,1);
    dc(1) = -k(2)*c(1) + k(1)*Ca;
    dc(2) = 0;
end

end

