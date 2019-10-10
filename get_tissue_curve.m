% get_tissue_curve.m
%
% Author: Tom Morin
% Date: July, 2015
% Purpose: Get a bolus + continuous infusion tissue curve for a specific
% radiotracer, ROI, and reference region.  OR use compartment models to
% derive a tissue curve for a specific radiotracer, ROI, and reference
% tissue

%%
function tac = get_tissue_curve(model, radiotracer, input, region, region_value, time, kbol, Ca, k, kr, origin, use_sim)

tracer_props = get_properties2(radiotracer);

% BOLUS PLUS CONTINUOUS INFUSION
if strcmp(input,'Bolus & Infusion')            
    null = 0;
    t = [0:0.5:time];
    Ca = get_InputFunc(null,'Bolus',t);
    k_vals = tracer_props.TwoTC.k;
    % FOR THE ROI...
    if strcmp(origin,'roi')            
        if use_sim
            % SIMULATION (convert bolus input to B/I)
            disp(['SIMULATING...' use_sim]);
            k = get_k_vals(k_vals,region);
            a = run_2TC_model(tracer_props, region, time, Ca, model, k, kr, origin);
        else
            % REAL DATA (from file)
            raw = importdata(tracer_props.bolus_curve);
            a(1,:) = raw.data(:,1)'./60;
            a(2,:) = raw.data(:,region_value)';
        end    
    % FOR THE REFERENCE TISSUE...
    else
        if use_sim
            if strncmp(model,'1-Tissue',8)
                a = run_1TC_model(tracer_props, region, time, Ca, kr, kr, origin);
            elseif strncmp(model, 'Plasma', 6)
                a(1,:) = [0:0.5:time];
                a(2,:) = Ca;
            end
%                     % SIMULATION (convert bolus input to B/I)
%             disp(['SIMULATING...' use_sim]);
%             k = get_k_vals(k_vals,region);
%             a = run_2TC_model(tracer_props, region, time, Ca, model, k, kr, origin);
        else
            % REAL DATA (from file)
            raw = importdata(tracer_props.bolus_curve);
            a(1,:) = raw.data(:,1)'./60;
            a(2,:) = raw.data(:,region_value)';
        end    

    end
    % *************** Converting 1-TC or Cp to B/I input **************
    % Interpolate TAC for desired time span
    target(1,:) = [0:0.5:time];
    target(2,:) = pchip(a(1,:),a(2,:),target(1,:));
    
    % Integrate TAC
    integrated_target = zeros(1,length(target));
    for m=1:length(target)
        if m == 1
            integrated_target(1,m) = target(2,m);
        else
            integrated_target(1,m) = (target(2,m) * (target(1,m) - target(1,m-1))) + integrated_target(1,m-1);
        end
    end
    
    % Use optimized kbol to calculate bolus + infusion tissue curve
    dose_b = (kbol / (kbol + time));
    dose_i = 1 - dose_b;
    tac(1,:) = target(1,:);
    tac(2,:) = (dose_b.*target(2,:)) + (dose_i.*((1./time).*integrated_target));
    % *****************************************************************

% OTHER METHODS
else
    if strncmp(model,'1-Tissue',8)
        tac = run_1TC_model(tracer_props, region, time, Ca, k, kr, origin);
    elseif strncmp(model, '2-Tissue',8)
        tac = run_2TC_model(tracer_props, region, time, Ca, model, k, kr, origin);
    elseif strncmp(model, 'Plasma', 6)
        tac(1,:) = [0:0.5:time];
        tac(2,:) = Ca;
    end
end

end

% %% 1-Tissue Compartment Model
% function tac = run_1TC_model(tracer_props, region, time, Ca, rate_const, ref_rate_const, origin)
% global k
% global kr
% global k_da
% global kp
% % Get k-values
% % For ROI 1-TC Model, use k1 & k2
% if strcmp(origin,'roi')
%     k = rate_const;
%     kr = ref_rate_const;
%     % For Reference 1-TC Model, use kr values
% else
%     k = ref_rate_const;
%     kr = ref_rate_const;
% end
% kp = tracer_props.kp;
% k_da = NaN;
% 
% % Set challenge data to flat line/baseline levels (no challenge)
% t = [0:0.5:time];
% tCa = t;
% t_EN = t;
% NT = zeros(1,length(t));
% NT(1,:) = 100;
% tac = zeros(2,length(t));
% 
% % Solve the ODE
% [T,C] = ode23s(@(t,c) ode_1tc_da(t,c,tCa,Ca,t_EN,NT),t,[0,0]);
% tac(1,:) = T';
% tac(2,:) = C(:,1)';
% end

% %% 2-Tissue Compartment Model
% function tac = run_2TC_model(tracer_props, region, time, Ca, model, rate_const, ref_rate_const, origin)
% global k
% global kr
% global k_da
% global kp
% % Get k-values
% k = rate_const;
% kr = tracer_props.kr;
% kp = tracer_props.kp;
% k_da = NaN;
% 
% % Adjust k-values if Irreversible Model
% if strcmp('2-Tissue Irreversible', model)
%     k(4) = 0;
%     kp(4) = 0;
% end
% 
% % Set challenge data to flat line/baseline levels (no challenge)
% t = [0:0.5:time];
% tCa = t;
% t_EN = t;
% NT = zeros(1,length(t));
% NT(1,:) = 100;
% tac = zeros(2,length(t));
% 
% % Solve the ODE
% [T,C] = ode23s(@(t,c) ode_2tc_da(t,c,tCa,Ca,t_EN,NT),t,[0,0,0]);
% free = C(:,1)';
% bound = C(:,2)';
% assignin('base','free',free);
% assignin('base','bound',bound);
% tissue = free + bound;
% 
% tac(1,:) = T';
% tac(2,:) = tissue;
% end



