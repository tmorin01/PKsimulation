function dx = ode_srtm(p, t, r)
    % Formats the ODE to the matlab specific format for ode23s solver
    % p = unknown parameters
    % t = time vector
    % ref = reference region TAC data
    % roi = region of interest TAC data
    
    % Differential equation for SRTM
    % r(1) = reference region
    % r(2) = derivative of reference region
    % r(3) = region of interest
    dx = p(1).*r(:,2) + p(2).*r(:,1) - p(3).*r(:,3);
    assignin('base','dx',dx);

end

% http://www.mathworks.com/matlabcentral/answers/77395-matlab-code-for-system-of-differential-equations-chemical-kinetics-fitting-to-data