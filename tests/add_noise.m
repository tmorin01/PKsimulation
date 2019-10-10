% NO LONGER USED IN PK SIM (7/1/15)
%
% Author: Tom Morin
% Date: June 2015
%
%%
function y2 = add_noise(x,y1,noise_factor)
% Add noise to a curve
% INPUT: 
%   x = list of x-values
%   y1 = list of original y-values
% OUTPUT: y2 = y-values after noise has been added

y2 = zeros(1,length(x));
for m=1:length(x)
    y2(1,m) = y1(1,m) + noise_factor*rand(1);
end