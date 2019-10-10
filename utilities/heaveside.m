% heaveside.m
%
% Author: Tom Morin
% Date: June, 2015
%
% Purpose: Create a heaveside step distribution for time-series t
%
% Heaveside step funciton, a/k/a unit step function is piecewise defined as:
%         =
%        | 0    if t < 0
% u(t) = { 0.5  if t == 0
%        | 1    if t > 0
%         =

function answer = heaveside( t )

answer = zeros(size(t));
for m=1:length(t)
    if t(m) < 0
        answer(m) = 0;
    elseif t(m) == 0
        answer(m) = 0.5;
    else
        answer(m) = 1;
    end
end

end

