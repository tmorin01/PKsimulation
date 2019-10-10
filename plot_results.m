% plot_results.m
% 
% Author: Tom Morin
% Modified By: Tom Morin
% Date: June 2015
%
% Purpose: Plot results of the simulation in PK Simulation
%

% Plot simulated data on the GUI
function plot_results(plot_data,chal_times,handles)
assignin('base','plot_data', plot_data)

global num_kbol Kbol ax h1 h2 l1 l2 l3 l4 l5 l6;
num_lines = 0;

% Clear previous plots
if ~isempty(ax)
    reset(h1);
    reset(h2);
end

% Colors for plotting
color = {[0.0 0.4 1.0], [0.0 0.4 0.84], [0.0 0.4 0.68], [0.0 0.4 0.52] [0.0 0.4 0.36] [0.0 0.4 0.2]};
tissue_color    = [0.6, 0.0, 0.8];      % Purple
art_color       = [0.9, 0.0, 0.0];      % Red
free_color      = [0.0, 0.4, 0.84];     % Blue
bound_color     = [0.2, 0.2, 0.2];      % Black
bp_color        = [1.0, 0.4, 0.0];      % Orange

% Get user selections
contents = cellstr(get(handles.model, 'String'));
model = contents{get(handles.model, 'Value')};
contents = cellstr(get(handles.radiotracer, 'String'));
radiotracer = contents{get(handles.radiotracer, 'Value')};
contents = cellstr(get(handles.input, 'String'));
input = contents{get(handles.input, 'Value')};
num_chal = str2num(get(handles.num_challenges,'String'));
show_chal = get(handles.show_chal,'Value');

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Plot 2 Subplots if necessary
if get(handles.plot_pulse,'Value')
    % Clear all previously plotted data
    cla(handles.graph);
    cla(handles.subgraph1);
    cla(handles.subgraph2);
    delete(legend(handles.subgraph1))
    legend(handles.graph,'hide');
    set(handles.graph,'Visible','off');
    set(handles.subgraph1,'Visible','on');
    set(handles.subgraph2,'Visible','on');
    set(handles.panel,'Visible','on');
    
    % SUBGRAPH1 = simulation
    % 1-TISSUE COMPARTMENT MODEL
    if strncmp(model,'1-Tissue',8)
        l1 = plot(handles.subgraph1, plot_data.x(1,:), plot_data.y(1,:), 'Color', art_color, 'Linestyle', '--', 'Linewidth', 2);
        hold(handles.subgraph1,'on');
        l2 = plot(handles.subgraph1, plot_data.x(2,:), plot_data.y(2,:), 'Color', tissue_color, 'Linewidth', 2);
        hold(handles.subgraph1,'off');
        hleg = legend(handles.subgraph1, 'Arterial Input', 'Tracer in Tissue', 'Location', 'best');
        set(hleg,'FontSize',11);
        title(handles.subgraph1, [model ' Model: ' radiotracer ' via ' input ' Input'], 'FontWeight', 'bold','FontSize',12,'Interpreter','none');
        xlabel(handles.subgraph1, 'Time (min.)','FontSize',10,'FontName','Arial','FontWeight','bold');
        ylabel(handles.subgraph1, 'Radioactivity (arb. units)','FontSize',10,'FontName','Arial','FontWeight','bold');
        set(handles.plotline1,'String','Arterial Input');
        set(handles.plotline2,'String','Tracer in Tissue');
        num_lines = 2;
    % 2-TISSUE COMPARTMENT MODEL
    elseif strncmp(model,'2-Tissue',8)
        l1 = plot(handles.subgraph1, plot_data.x(1,:), plot_data.y(1,:), 'Color', art_color, 'Linestyle', '--','Linewidth',2);
        hold(handles.subgraph1,'on');
        l2 = plot(handles.subgraph1, plot_data.x(2,:), plot_data.y(2,:), 'Color', free_color, 'Linestyle', '-.','Linewidth',2);
        l3 = plot(handles.subgraph1, plot_data.x(3,:), plot_data.y(3,:), 'Color', bound_color, 'Linewidth',2);
        l4 = plot(handles.subgraph1, plot_data.x(4,:), plot_data.y(4,:), 'Color', tissue_color, 'Linewidth', 2);
        hold(handles.subgraph1,'off');
        hleg = legend(handles.subgraph1, 'Arterial Input', 'Non-Displaceable', 'Specific Binding', 'Tissue Curve',...
            'Location', 'best');
        set(hleg,'FontSize',11);
        title(handles.subgraph1, [model ' Model: ' radiotracer ' via ' input ' Input'], 'FontWeight', 'bold','FontSize',12,'Interpreter','none');
        xlabel(handles.subgraph1, 'Time (min.)','FontSize',10,'FontName','Arial','FontWeight','bold');
        ylabel(handles.subgraph1, 'Radioactivity (arb. units)','FontSize',10,'FontName','Arial','FontWeight','bold');
        set(handles.plotline1,'String','Arterial Input');
        set(handles.plotline2,'String','Non-Displaceable Compartment');
        set(handles.plotline3,'String','Specific Binding Compartment');
        set(handles.plotline4,'String','Tissue Curve');
        num_lines = 4;
    % BOLUS + CONTINUOUS INFUSION OPTIMIZATION
    elseif strncmp(model,'Bolus/Inf',9)
        cla(handles.subgraph1);
        for m=1:num_kbol
            temp = plot(handles.subgraph1, plot_data.x(m,:), plot_data.y(m,:),...
                'Color', color{1,m}, 'Linewidth', 2, 'DisplayName', ['Kbol = ' num2str(Kbol(m))]);
            hold(handles.subgraph1,'on');
            if m==1, l1 = temp; set(handles.plotline1,'String',['Kbol = ' num2str(Kbol(m))]);
            elseif m==2, l2 = temp; set(handles.plotline2,'String',['Kbol = ' num2str(Kbol(m))]);
            elseif m==3, l3 = temp; set(handles.plotline3,'String',['Kbol = ' num2str(Kbol(m))]);
            elseif m==4, l4 = temp; set(handles.plotline4,'String',['Kbol = ' num2str(Kbol(m))]);
            elseif m==5, l5 = temp; set(handles.plotline5,'String',['Kbol = ' num2str(Kbol(m))]);
            elseif m==6, l6 = temp; set(handles.plotline6,'String',['Kbol = ' num2str(Kbol(m))]);
            end
        end
        hleg = legend(handles.subgraph1, 'show', 'Location', 'best');
        set(hleg,'FontSize',11);
        title(handles.subgraph1, [radiotracer ' via ' input ' Input'], 'FontWeight', 'bold','FontSize',12,'Interpreter','none');
        xlabel(handles.subgraph1, 'Time (min.)','FontSize',10,'FontName','Arial');
        ylabel(handles.subgraph1, 'Radioactivity (arb. units)','FontSize',10,'FontName','Arial') 
        hold(handles.subgraph1, 'off');
        num_lines = num_kbol;
    % SIMPLIFIED REFERENCE TISSUE MODEL
    elseif strncmp(model,'SRTM',4)
        [ax, h1, h2] = plotyy(handles.subgraph1, plot_data.x(4,:), plot_data.y(4,:),...
            [plot_data.x(2,:)', plot_data.x(3,:)'],...
            [plot_data.y(2,:)', plot_data.y(3,:)']);
        l1 = h1;
        l2 = h2;
        set(handles.graph,'Visible','off');
        set(ax(2),'Visible','on');
        set(ax(1),'Visible','on','YColor',bp_color);
        set(h1,'Linewidth',2,'Color',bp_color);
        set(h2,'Linewidth',2);
        set(h2(1),'Color',tissue_color);
        set(h2(2),'Color',free_color,'Linestyle','-.');
        set(ax(2),'FontSize',10);
        set(handles.subgraph1,'FontSize',10);
        ylabel(ax(2),'Radioactivity (arb. units)','FontSize',10,'FontName','Arial','FontWeight','bold');
        ylabel(ax(1),'Binding Potential','FontSize',10,'FontName','Arial','FontWeight','bold','Color',bp_color);
        xlabel(handles.subgraph1,'Time (min.)','FontSize',10,'FontName','Arial','FontWeight','bold');
        hleg = legend(handles.subgraph1, 'Binding Potential', 'Region of Interest', 'Reference Region', 'Location', 'Best');
        set(hleg, 'FontSize', 11);
        title(handles.subgraph1, ['SRTM Model: ' radiotracer], 'FontSize', 12, 'FontWeight','bold');
        set(handles.plotline1,'String','Binding Potential');
        set(handles.plotline2,'String','Tissue Curves');
        num_lines = 2;
    % LOGAN REFERENCE PLOT
    elseif strncmp(model, 'Logan Reference',15)
        axes(handles.subgraph1);
        hold (handles.subgraph1, 'on');
        l1 = plot(plot_data.x(1,:),plot_data.y(1,:),'o','Color',[0.6 0.8 1.0]);
        l2 = plot(plot_data.fitresult);
        set(handles.plotline1,'String','Linear Fit');
        set(handles.plotline2,'String','Data Points');
        hleg = legend(handles.subgraph1, 'Data Points', 'Linear Fit', 'Location', 'best');
        set(hleg,'FontSize',12);
        title(handles.subgraph1, ['Logan Reference Model: ' radiotracer], 'FontSize', 12, 'FontWeight','bold');
        x_string = '$$ {\frac{{\int_{0}^{T} C_r dt}+{\frac{C_r}{k_2^,}}}{C_T}} $$';
        y_string = '$$ {\frac{\int_{0}^{T} C_T dt}{C_T}} $$';
        xlabel(handles.subgraph1,x_string,'FontSize',12,'FontName','Arial','Fontweight','bold','Interpreter','latex');
        ylabel(handles.subgraph1,y_string,'FontSize',12,'FontName','Arial','Fontweight','bold','Interpreter','latex');
        hold(handles.subgraph1,'off');
        num_lines = 2;
        figure(1);
    end
    set(handles.subgraph1,'FontSize',8);
    
    % SUBGRAPH2 = Neurotransmitter pulses
    plot(handles.subgraph2, plot_data.x(1,:), plot_data.NT, 'Linewidth', 2, 'Color', [0.1 0.7 0.8]);
    assignin('base','NT',plot_data.NT);
    hold(handles.subgraph2, 'on');
    xlabel(handles.subgraph2, 'Time (min.)','FontSize',10,'FontName','Arial','FontWeight','bold');
    ylabel(handles.subgraph2, 'Endogenous NT (nM)','FontSize',10,'FontName','Arial','FontWeight','bold')
    title(handles.subgraph2, 'Endogenous Challenge(s)', 'FontWeight', 'bold','FontSize',12);
    set(handles.subgraph2,'FontSize',8);
    hold(handles.subgraph2,'off');

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
% Otherwise, just plot the simulation on one graph
else
    % Clear all previously plotted data
    cla(handles.graph);
    cla(handles.subgraph1);
    cla(handles.subgraph2);
    delete(legend(handles.graph));
    legend(handles.subgraph1,'hide');
    set(handles.subgraph1,'Visible','off');
    set(handles.subgraph2,'Visible','off');
    set(handles.panel,'Visible','on');
    set(handles.graph,'Visible','on');
    
    % GRAPH = Single plot of simulation    
    % 1-TISSUE COMPARTMENT MODEL
    if strncmp(model,'1-Tissue',8)
        l1 = plot(handles.graph, plot_data.x(1,:), plot_data.y(1,:), 'Color', art_color, 'Linestyle', '--', 'Linewidth', 2);
        hold(handles.graph,'on');
        l2 = plot(handles.graph, plot_data.x(2,:), plot_data.y(2,:), 'Color', tissue_color, 'Linewidth', 2);
        hold(handles.graph,'off');
        title(handles.graph, [model ' Model: ' radiotracer ' via ' input ' Input'], 'FontWeight', 'bold','FontSize',12,'Interpreter','none');
        legend(handles.graph, 'Arterial Input', 'Tracer in Tissue', 'Location', 'best','FontSize',12);
        xlabel(handles.graph, 'Time (min.)','FontSize',10,'FontName','Arial');
        ylabel(handles.graph, 'Radioactivity (arb. units)','FontSize',10,'FontName','Arial');
        set(handles.plotline1,'String','Arterial Input');
        set(handles.plotline2,'String','Tracer in Tissue');
        num_lines = 2;    
    % 2-TISSUE COMPARTMENT MODEL
    elseif strncmp(model,'2-Tissue',8)
        l1 = plot(handles.graph, plot_data.x(1,:), plot_data.y(1,:), 'Color', art_color, 'Linestyle', '--','Linewidth',2);
        hold(handles.graph, 'on');
        l2 = plot(handles.graph, plot_data.x(2,:), plot_data.y(2,:), 'Color', free_color, 'Linestyle', '-.','Linewidth',2);
        l3 = plot(handles.graph, plot_data.x(3,:), plot_data.y(3,:), 'Color', bound_color, 'Linewidth',2);
        l4 = plot(handles.graph, plot_data.x(4,:), plot_data.y(4,:), 'Color', tissue_color, 'Linewidth', 2);
        hold(handles.graph, 'off');
        title(handles.graph, [model ' Model: ' radiotracer ' via ' input ' Input'], 'FontWeight', 'bold','FontSize',12,'Interpreter','none');
        hleg = legend(handles.graph, 'Arterial Input', 'Non-Displaceable', 'Specific Binding', 'Tissue Curve',...
            'Location', 'best');
        set(hleg,'FontSize',12);
        xlabel(handles.graph, 'Time (min.)','FontSize',10,'FontName','Arial');
        ylabel(handles.graph, 'Radioactivity (arb. units)','FontSize',10,'FontName','Arial');
        set(handles.plotline1,'String','Arterial Input');
        set(handles.plotline2,'String','Non-Displaceable Compartment');
        set(handles.plotline3,'String','Specific Binding Compartment');
        set(handles.plotline4,'String','Tissue Curve');
        num_lines = 4;    
    % BOLUS + CONTINUOUS INFUSION OPTIMIZATION
    elseif strncmp(model,'Bolus/Inf',9)
        cla(handles.graph);
        for m=1:num_kbol
            temp = plot(handles.graph, plot_data.x(m,:), plot_data.y(m,:),...
                'Color', color{1,m}, 'Linewidth', 2, 'DisplayName', ['Kbol = ' num2str(Kbol(m))]);
            hold(handles.graph,'on');
            if m==1, l1 = temp; set(handles.plotline1,'String',['Kbol = ' num2str(Kbol(m))]);
            elseif m==2, l2 = temp; set(handles.plotline2,'String',['Kbol = ' num2str(Kbol(m))]);
            elseif m==3, l3 = temp; set(handles.plotline3,'String',['Kbol = ' num2str(Kbol(m))]);
            elseif m==4, l4 = temp; set(handles.plotline4,'String',['Kbol = ' num2str(Kbol(m))]);
            elseif m==5, l5 = temp; set(handles.plotline5,'String',['Kbol = ' num2str(Kbol(m))]);
            elseif m==6, l6 = temp; set(handles.plotline6,'String',['Kbol = ' num2str(Kbol(m))]);
            end
        end
        legend(handles.graph, 'show', 'Location', 'best');
        title(handles.graph, [radiotracer ' via ' input ' Input'], 'FontWeight', 'bold','FontSize',12,'Interpreter','none');
        xlabel(handles.graph, 'Time (min.)','FontSize',10,'FontName','Arial');
        ylabel(handles.graph, 'Radioactivity (arb. units)','FontSize',10,'FontName','Arial') 
        hold(handles.graph, 'off');
        num_lines = num_kbol;
    % SIMPLIFIED REFERENCE TISSUE MODEL
    elseif strncmp(model,'SRTM',4)
        [ax, h1, h2] = plotyy(handles.graph, plot_data.x(4,:), plot_data.y(4,:),...
            [plot_data.x(2,:)', plot_data.x(3,:)'],...
            [plot_data.y(2,:)', plot_data.y(3,:)']);
        l1 = h1;
        l2 = h2;
        set(ax(2),'Visible','on');
        set(ax(1),'Visible','on','YColor',bp_color);
        set(h1,'Linewidth',2,'Color',[1, 0.4, 0]);
        set(h2,'Linewidth',2);
        set(h2(1),'Color',tissue_color);
        set(h2(2),'Color',free_color,'Linestyle','-.');
        set(ax(2),'FontSize',12);
        set(handles.graph,'FontSize',12);
        ylabel(ax(2),'Radioactivity (arb. units)','FontSize',12,'FontName','Arial','FontWeight','bold');
        ylabel(ax(1),'Binding Potential','FontSize',12,'FontName','Arial','FontWeight','bold','Color',bp_color);
        xlabel(handles.graph,'Time (min.)','FontSize',12,'FontName','Arial','FontWeight','bold');
        hleg = legend(handles.graph, 'Binding Potential', 'Region of Interest', 'Reference Region', 'Location', 'Best');
        set(hleg, 'FontSize', 12);
        title(handles.graph, ['SRTM Model: ' radiotracer]);
        set(handles.plotline1,'String','Binding Potential');
        set(handles.plotline2,'String','Tissue Curves');
        num_lines = 2;
    % LOGAN REFERENCE PLOT
    elseif strncmp(model, 'Logan Reference',15)
        axes(handles.graph);
        hold on;
        l1 = plot(plot_data.x(1,:),plot_data.y(1,:),'o','Color',[0.6 0.8 1.0]);
        l2 = plot(plot_data.fitresult);
        set(handles.plotline1,'String','Linear Fit');
        set(handles.plotline2,'String','Data Points');
        hold(handles.graph, 'off');
        title(handles.graph, ['Logan Reference Model: ' radiotracer],'FontName','Arial','FontWeight','bold');
        hleg = legend(handles.graph, 'Data Points', 'Linear Fit', 'Location', 'best');
        set(hleg,'FontSize',12);
        x_string = '$$ {\frac{{\int_{0}^{T} C_r dt}+{\frac{C_r}{k_2^,}}}{C_T}} $$';
        y_string = '$$ {\frac{\int_{0}^{T} C_T dt}{C_T}} $$';
        xlabel(handles.graph,x_string,'FontSize',12,'FontName','Arial','Fontweight','bold','Interpreter','latex');
        ylabel(handles.graph, y_string,'FontSize',12,'FontName','Arial','Fontweight','bold','Interpreter','latex');
        num_lines = 2;
        figure(1);
    end       
end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% If selected, show challenges on graph (verticle green lines)
if show_chal
    if num_chal > 0
        for m=1:num_chal
            vert = chal_times(m);
            if get(handles.plot_pulse,'Value')
                hold(handles.subgraph1, 'on');
                hold(handles.subgraph2, 'on');
                plot(handles.subgraph1,[vert vert],get(handles.subgraph1,'YLim'),'-g');
                plot(handles.subgraph2,[vert vert],get(handles.subgraph2,'YLim'),'-g');
            else
                hold(handles.graph, 'on');
                plot(handles.graph,[vert vert],get(handles.graph,'YLim'),'-g');
            end
        end
        % Remove all holds
        hold(handles.graph, 'off');
        hold(handles.subgraph1, 'off');
        hold(handles.subgraph2, 'off');
    end
end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Show Plot Line Checkboxes
boxes = {'plotline1','plotline2','plotline3','plotline4','plotline5','plotline6'};
if num_lines > 0
    for m=1:num_lines
        set(handles.(boxes{m}),'Visible','on','Value',1);
    end
end
for m = num_lines+1:6
    set(handles.(boxes{m}),'Visible','off','Value',0);
end
    


end