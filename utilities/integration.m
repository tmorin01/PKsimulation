function [ output ] = integration( X )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
output = zeros(1,length(X));
for m=1:length(X)
    if m==1
        output(1,1) = X(1,1);
    else
        output(1,m) = 0.5.*X(1,m) + output(1,m-1);
    end
end

end

