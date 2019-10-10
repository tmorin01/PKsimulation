%% 2-Tissue Compartment Model
function tac = run_2TC_model(tracer_props, region, time, Ca, model, rate_const, ref_rate_const, origin)
global k
global kr
global k_da
global kp
% Get k-values
k = rate_const;
kr = tracer_props.kr;
kp = tracer_props.kp;
k_da = NaN;

% Adjust k-values if Irreversible Model
if strcmp('2-Tissue Irreversible', model)
    k(4) = 0;
    kp(4) = 0;
end

% Set challenge data to flat line/baseline levels (no challenge)
t = [0:0.5:time];
tCa = t;
t_EN = t;
NT = zeros(1,length(t));
NT(1,:) = 100;
tac = zeros(2,length(t));

% Solve the ODE
[T,C] = ode23s(@(t,c) ode_2tc_da(t,c,tCa,Ca,t_EN,NT),t,[0,0,0]);
free = C(:,1)';
bound = C(:,2)';
assignin('base','free',free);
assignin('base','bound',bound);
tissue = free + bound;

tac(1,:) = T';
tac(2,:) = tissue;
end

