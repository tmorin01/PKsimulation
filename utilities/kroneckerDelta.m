% kroneckerDelta.m
%
% Author: Tom Morin
% Date: June, 2015
%
% Purpose: Create a Kronecker's Delta distribution for time-series t
%
% Kronecker's Delta function is piecewise defined as:
%         =
%        | 1    if t == 0
% u(t) = { 
%        | 0    if t ~= 0
%         =

function answer = kroneckerDelta( t )

answer = zeros(size(t));
for m=1:length(t)
    if t(m) == 0
        answer(m) = 1;
    else
        answer(m) = 0;
    end
end

end

