%% 1-Tissue Compartment Model
function tac = run_1TC_model(tracer_props, region, time, Ca, rate_const, ref_rate_const, origin)
global k
global kr
global k_da
global kp
% Get k-values
% For ROI 1-TC Model, use k1 & k2
if strcmp(origin,'roi')
    k = rate_const;
    kr = ref_rate_const;
    % For Reference 1-TC Model, use kr values
else
    k = ref_rate_const;
    kr = ref_rate_const;
end
kp = tracer_props.kp;
k_da = NaN;

% Set challenge data to flat line/baseline levels (no challenge)
t = [0:0.5:time];
tCa = t;
t_EN = t;
NT = zeros(1,length(t));
NT(1,:) = 100;
tac = zeros(2,length(t));

% Solve the ODE
[T,C] = ode23s(@(t,c) ode_1tc_da(t,c,tCa,Ca,t_EN,NT),t,[0,0]);
tac(1,:) = T';
tac(2,:) = C(:,1)';
end

