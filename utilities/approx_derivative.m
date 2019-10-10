function derived_data = approx_derivative(data)
% 'data' is a matrix of time series statistics
% x = first row of 'data'
% y = second row of 'data'

derived_data = zeros(1,length(data));
for m=1:length(data)-1
    if m == length(data)-1
        derived_data(1,m) = derived_data(1,m-1);
    else
        derived_data(1,m) = (data(2,m+1) - data(2,m)) ./ (data(1,m+1));
    end
end