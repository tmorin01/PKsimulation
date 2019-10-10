% ode_2tc_da.m
% 
% Author: Hsiao-Ying (Monica) Wey
% Modified By: Tom Morin
% Date: June 2015
%
% Purpose: Present differential equations that describe a 2-Tissue
% Compartment Model with the option of an endogenous challenge.  These
% equations are used to produce a solution with built-in solver ode23s.m
%
function dc = ode_2tc_da(t,c,tCa,Ca,t_EN,NT)

%global k
global k k_da kp
Bmax = 54;

Ca = interp1(tCa,Ca,t);

NT = interp1(t_EN,NT,t);


% Differential equations
% c(1): Free, c(2): Bound, c(3): Bound_EN
% 
% dc = zeros(2,1);        % a column vector
% dc(1) = k(1)*Ca - (k(2)+k(3))*c(1) + k(4)*c(2);   
% dc(2) = k(3) *c(1) - k(4)*c(2); 


% Within scan challenge, assuming k' (kp) values
%if t<td
if ~isnan(k_da)
    dc = zeros(3,1);
    dc(1) = -k(2)*c(1) + k(4)*c(2) + k(1)*Ca - k(3)*(Bmax-c(2)-c(3))*c(1);
    dc(2) =      k(3) *c(1)*(Bmax-c(2)-c(3)) - k(4)*c(2);
    dc(3) = k_da(1)*(Bmax-c(2)-c(3))*NT - k_da(2)*c(3);

elseif ~isnan(k)
    dc = zeros(3,1);
    dc(1) = -(k(2)+k(3))*c(1) + k(4)*c(2) + k(1)*Ca;
    dc(2) =     k(3) *c(1) - k(4)*c(2);
    dc(3) = 0;

elseif ~isnan(kp)
    dc = zeros(3,1);
    dc(1) = -(kp(2)+kp(3))*c(1) + kp(4)*c(2) + kp(1)*Ca;
    dc(2) =      kp(3) *c(1) - kp(4)*c(2);
    dc(3) = 0;
end


end
