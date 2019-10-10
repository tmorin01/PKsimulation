function SSE = SRTM_objective(td, ref, roi, p, x0)

    % Calculate the derivative of the reference region
    d_ref = diff(ref(:,1));
    d_ref(end+1,1) = 0;

    r(:,1) = ref;
    r(:,2) = d_ref;
    r(:,3) = roi;
    assignin('base','r',r);

    f = @(t,c) ode_srtm(p,t,r);
    [ts,xs] = ode45(f,td,x0);
    assignin('base','xs',xs);
    %err = roi - xs;
    %SSE = sum(err.^2);
end