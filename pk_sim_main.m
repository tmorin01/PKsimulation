% Main function for PK Simulation
%
% Author: Tom Morin
% Date: June 2015
%
%%
function [plot_data] = pk_sim_main(model, radiotracer, input, competition, time, noise, chal_times, amplitude, handles)

global roi_tac reference_tac k2_prime_fixed;

plot_data.z = 0;
clear('plot_data');

% Get radiotracer properties
tracer_props = get_properties2(radiotracer);

%t = 0:(1/60):time; % Array of times in seconds
t = 0:0.5:time; % Array of times in minutes
bar = waitbar(0.1, 'Simulating scan times longer than 15 minutes may take some time... - 10%');

if (~strcmp(model,'SRTM') && ~strcmp(model,'Logan Reference'))
    % Get input function
    input_func = get_InputFunc(handles, input, t);
end
bar = waitbar(0.3, bar, 'Simulating scan times longer than 15 minutes may take some time... - 30%');

% Run simulation and plot model
switch model
    case '2-Tissue Compartment'
        plot_data = model2TC_DA_v2(tracer_props, input_func, t, competition, noise, chal_times, amplitude, handles);
        if (get(handles.fit_data, 'Value'))
            fit_params_2TC_DA(plot_data);
        end
    case '2-Tissue Irreversible'
        plot_data = model2TC_DA_v2(tracer_props, input_func, t, competition, noise, chal_times, amplitude, handles);
    case '1-Tissue Compartment'
        plot_data = model1TC_DA(tracer_props, input_func, t, competition, noise, chal_times, amplitude, handles);
    case 'Bolus/Infusion Optimization'
        global num_kbol;
        plot_data = bolus_infusion_sim(input_func, t, competition, noise, chal_times, handles, num_kbol);
    case 'SRTM'
        plot_data = SRTM_sim(roi_tac, reference_tac, handles, chal_times, amplitude, noise);
    case 'Logan Reference'
        plot_data = logan_sim(roi_tac, reference_tac, k2_prime_fixed, handles, chal_times, amplitude, noise);
    otherwise
        warndlg('Model not available. pk_sim_main.m');
end
bar = waitbar(0.9, bar, 'Simulating scan times longer than 15 minutes may take some time... - 90%');

close(bar);

end


function fit_params_2TC_DA(plot_data)
% method to fit parameters of ODE model to previously simulated data
% SOURCE: http://www.math.pitt.edu/~swigon/math1360.html
% main program for fitting parameters of an ODE model to data
% the model and the error function are defined in the file Sfun2D.m

clear_globals;

global tdata xdata x0

% tdata(:,1) = zeros(length(plot_data.x(1,:)));
% xdata = zeros(3,(length(plot_data.x(1,:))));

%% data for the model
% time  - value of 1st variable - value of 2nd variable 

START = 30;

% if (length(plot_data.y(1,:)) > length(plot_data.y(:,1)))
    tdata = plot_data.x(1,START:end)';
    xdata(:,1) = (plot_data.y(1,START:end))';
    xdata(:,2) = (plot_data.y(2,START:end))';
    xdata(:,3) = (plot_data.y(3,START:end))';
% else
%     tdata = plot_data.x(1,:);
%     xdata(:,1) = plot_data.y(1,:);
%     xdata(:,2) = plot_data.y(2,:);
%     xdata(:,3) = plot_data.y(3,:);
% end

% tdata(1) = 0.5; xdata(1,1) = 99;   xdata(1,2) = 2;    
% tdata(2) = 1;   xdata(2,1) = 98;   xdata(2,2) = 4;   
% tdata(3) = 5;   xdata(3,1) = 50;   xdata(3,2) = 35;  
% tdata(4) = 20;  xdata(4,1) = 3;    xdata(4,2) = 7;   

%% initial conditions
assignin('base','xdata',xdata);
if (xdata(1,1) >= xdata(2,1))
    disp('init w/ max');
    x0(1) = max(xdata(:,1));
    x0(2) = 0;
    x0(3) = 0;
else
    disp('init w/ min');
    x0(1) = min(xdata(:,1));
    x0(2) = 0;
    x0(3) = 0;
end

%% initial guess of parameter values

b(1) = 0;
%b(2) = 0.37;
%b(3) = 0.38;
%b(4) = 0.11;

%% minimization step

[bmin, Smin] = fminsearch(@Sfun2D,b);

disp('Estimated parameters b(i):');
disp(bmin)
disp('Smallest value of the error S:');
disp(Smin)

end


function clear_globals()
clear global tdata;
clear global xdata;
clear global x0;
end


