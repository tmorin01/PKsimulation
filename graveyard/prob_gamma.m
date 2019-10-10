% gamma.m
% Author: Tom Morin
% Date: August, 2015
% Purpose: Create a gamma probability distribution

function output = gamma_var(h,tao,time)
% h = height parameter (if k=3, and theta = 10 height is the max of the curve)
% k = shift the curve left or right.  Large values of k shift right and slightly up
% theta = compress or decompress the curve.  Larger values compress the curve

if nargin < 4;
    h = 10;
    tao = 3;
    time = 100;
end

output(:,1) = [0:0.5:time];
for m=1:length(output);
    output(m,2) = h .* ( (output(m,1) ./ tao) .* exp(-1.*output(m,1) ./ tao) );
    %output(m,2) = 12 .* k .* h .* (1./(factorial(k-1).*(theta.^k))) .* (output(m,1).^(k-1)) .* exp(-1.*output(m,1)./theta);
end
end