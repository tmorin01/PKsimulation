% save_results.m
%
% Author: Tom Morin
% Date: June, 2015
%
% Purpose: Save the current figure in PK Simulation to an image file (PNG
% format).

function save_results(plot_data,chal_times,handles)
% Save simulated data to an image file

global num_kbol Kbol ax h1 h2;

% Color order for plotting B/I Optimization
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

f = handles.subgraph1;
g = handles.subgraph2;
h = handles.graph;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Plot 2 Subplots if necessary
if get(handles.plot_pulse,'Value')
    % ********** SUBGRAPH1 = simulation **********
    h = figure;
    %set(h,'Visible','off');
    f = subplot(2,1,1);        
    hold(f,'on');
    title(f,[model ' Model: ' radiotracer ' via ' input ' Input'], 'FontWeight', 'bold','FontSize',10);
    % 1-TISSUE COMPARTMENT MODEL
    if strncmp(model,'1-Tissue',8)
        plot(f, plot_data.x(1,:), plot_data.y(1,:), 'Color', art_color, 'Linestyle', '--', 'Linewidth', 2)
        plot(f, plot_data.x(2,:), plot_data.y(2,:), 'Color', tissue_color, 'Linewidth', 2);
        legend(f, 'Arterial input', 'Tracer in Tissue', 'Location', 'best');
        xlabel(f,'Time (min.)','FontSize',10,'FontName','Arial');
        ylabel(f,'Radioactivity (arb. units)','FontSize',10,'FontName','Arial');
    % 2-TISSUE COMPARTMENT MODEL
    elseif strncmp(model,'2-Tissue',8)
        plot(f, plot_data.x(1,:), plot_data.y(1,:), 'Color', art_color, 'Linestyle', '--', 'Linewidth', 2);
        hold(f,'on');
        plot(f, plot_data.x(2,:), plot_data.y(2,:), 'Color', free_color, 'Linestyle', '-.', 'Linewidth', 2);
        plot(f, plot_data.x(3,:), plot_data.y(3,:), 'Color', bound_color, 'Linewidth', 2);
        plot(f, plot_data.x(4,:), plot_data.y(4,:), 'Color', tissue_color, 'Linewidth', 2);
        hold(f, 'off');
        hleg = legend(handles.subgraph1, 'Arterial Input', 'Non-Displaceable', 'Specific Binding', 'Tissue Curve',...
            'Location', 'best');
        xlabel(f,'Time (min.)','FontSize',10,'FontName','Arial');
        ylabel(f,'Radioactivity (arb. units)','FontSize',10,'FontName','Arial');
    % BOLUS + CONTINUOUS INFUSION OPTIMIZATION
    elseif strncmp(model,'Bolus/Inf',9)
        hold(f,'on');
        for m=1:num_kbol
            plot(f, plot_data.x(m,:), plot_data.y(m,:),...
                'Color', color{1,m}, 'Linewidth', 2, 'DisplayName', ['Kbol = ' num2str(Kbol(m))]);
        end
        hleg = legend(f, 'show', 'Location', 'best');
        set(hleg, 'FontSize', 7);
        hold(handles.subgraph1, 'off');
        title(f, [radiotracer ' via ' input ' Input'], 'FontWeight', 'bold','FontSize',10,'Interpreter','none');
        xlabel(f,'Time (min.)','FontSize',10,'FontName','Arial');
        ylabel(f,'Radioactivity (arb. units)','FontSize',10,'FontName','Arial');
    % SIMPLIFIED REFERENCE TISSUE MODEL
    elseif strncmp(model,'SRTM',4)
        [ax, h1, h2] = plotyy(f, plot_data.x(4,:), plot_data.y(4,:),...
            [plot_data.x(2,:)', plot_data.x(3,:)'],...
            [plot_data.y(2,:)', plot_data.y(3,:)']);
        set(f,'Visible','off');
        set(ax(2),'Visible','on');
        set(ax(1),'Visible','on','YColor',bp_color);
        set(h1,'Linewidth',2,'Color',bp_color);
        set(h2,'Linewidth',2);
        set(h2(1),'Color',tissue_color);
        set(h2(2),'Color',free_color,'Linestyle','-.');
        set(ax(2),'FontSize',10);
        set(f,'FontSize',10);
        ylabel(ax(2),'Radioactivity (arb. units)','FontSize',10,'FontName','Arial','FontWeight','bold');
        ylabel(ax(1),'Binding Potential','FontSize',10,'FontName','Arial','FontWeight','bold','Color',bp_color);
        xlabel(f,'Time (min.)','FontSize',10,'FontName','Arial','FontWeight','bold');
        hleg = legend(f, 'Binding Potential', 'Region of Interest', 'Reference Region', 'Location', 'Best');
        set(hleg, 'FontSize', 11);
        title(f, ['SRTM Model: ' radiotracer], 'FontSize', 12, 'FontWeight','bold');
    end
    set(f,'FontSize',8);
    
    % ********** SUBGRAPH2 = Neurotransmitter pulses ***********
    g = subplot(2,1,2);
    plot(g,plot_data.x(1,:), plot_data.NT, 'k', 'Linewidth', 2, 'Color', [0.1 0.7 0.8]);
    hold(g,'on');
    xlabel(g,'Time (min.)','FontSize',11,'FontName','Arial','Fontweight','bold');
    ylabel(g,'Endogenous NT (arb. units)','FontSize',11,'FontName','Arial','Fontweight','bold')
    title(g,'Endogenous Challenge(s)', 'FontWeight', 'bold','FontSize',12);
    set(g,'FontSize',7);
    set(ax(2),'Visible','on');

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
% Otherwise, just plot the simulation
else
    % GRAPH = Single plot of simulation
    h = figure;
    ha = axes;
    %set(h,'Visible','off');
    hold('on');
    title([model ' Model: ' radiotracer ' via ' input ' Input'], 'FontWeight', 'bold','FontSize',12);
    % 1-TISSUE COMPARTMENT MODEL
    if strncmp(model,'1-Tissue',8)
        plot(plot_data.x(1,:), plot_data.y(1,:), 'Color', art_color, 'Linestyle', '--', 'Linewidth', 2)
        hold('on');
        plot(plot_data.x(2,:), plot_data.y(2,:), 'Color', tissue_color, 'Linewidth', 2);
        hold('off');
        legend('Arterial Input', 'Tracer in Tissue', 'Location', 'best');
    % 2-TISSUE COMPARTMENT MODEL
    elseif strncmp(model,'2-Tissue',8)
        plot(plot_data.x(1,:), plot_data.y(1,:), 'Color', art_color, 'Linestyle', '--', 'Linewidth', 2);
        plot(plot_data.x(2,:), plot_data.y(2,:), 'Color', free_color, 'Linestyle', '-.', 'Linewidth', 2);
        plot(plot_data.x(3,:), plot_data.y(3,:), 'Color', bound_color, 'Linewidth', 2);
        plot(plot_data.x(4,:), plot_data.y(4,:), 'Color', tissue_color, 'Linewidth', 2);
        hleg = legend(handles.graph, 'Arterial Input', 'Non-Displaceable', 'Specific Binding', 'Tissue Curve',...
            'Location', 'best');
    % BOLUS + CONTINUOUS INFUSION OPTIMIZATION
    elseif strncmp(model,'Bolus/Inf',9)
        hold('on');
        for m=1:num_kbol
            plot(plot_data.x(m,:), plot_data.y(m,:),...
                'Color', color{1,m}, 'Linewidth', 2, 'DisplayName', ['Kbol = ' num2str(Kbol(m))]);
        end
        legend('show', 'Location', 'best');
        hold('off');
        title([radiotracer ' via ' input ' Input'], 'FontWeight', 'bold','FontSize',12,'Interpreter','none');
    % SIMPLIFIED REFERENCE TISSUE MODEL 
    elseif strncmp(model,'SRTM',4)
        [ax, h1, h2] = plotyy(plot_data.x(4,:), plot_data.y(4,:),...
            [plot_data.x(2,:)', plot_data.x(3,:)'],...
            [plot_data.y(2,:)', plot_data.y(3,:)']);
        set(ax(2),'Visible','on');
        set(ax(1),'Visible','on','YColor',bp_color);
        set(h1,'Linewidth',2,'Color',bp_color);
        set(h2,'Linewidth',2);
        set(h2(1),'Color',tissue_color);
        set(h2(2),'Color',free_color,'Linestyle','-.');
        set(ax(2),'FontSize',10);
        ylabel(ax(2),'Radioactivity (arb. units)','FontSize',10,'FontName','Arial','FontWeight','bold');
        ylabel(ax(1),'Binding Potential','FontSize',10,'FontName','Arial','FontWeight','bold','Color',bp_color);
        xlabel('Time (min.)','FontSize',10,'FontName','Arial','FontWeight','bold');
        hleg = legend('Binding Potential', 'Region of Interest', 'Reference Region', 'Location', 'Best');
        set(hleg, 'FontSize', 11);
        title(['SRTM Model: ' radiotracer], 'FontSize', 12, 'FontWeight','bold');
    end
    xlabel('Time (min.)','FontSize',10,'FontName','Arial');
    ylabel('Radioactivity (arb. units)','FontSize',10,'FontName','Arial')
    
end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% If selected, show challenges on graph (verticle green lines)
if show_chal
    if num_chal > 0
        for m=1:num_chal
            vert = chal_times(m);
            if get(handles.plot_pulse,'Value')
                hold(f,'on');
                hold(g,'on');
                axes(f);
                plot(f,[vert vert],get(gca,'YLim'),'-g');
                axes(g);
                plot(g,[vert vert],get(gca,'YLim'),'-g');
            else
                hold('on');
                axes(ha);
                plot(gca,[vert vert],get(gca,'YLim'),'-g');
            end
        end
    end
end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Open save dialogue and save the figure
set(gcf,'Position',[680 568 634 392]);
% [filename,pathname] = uiputfile('*.png', 'Save Current Graph', 'figure');
% saveas(h, fullfile(pathname,filename), 'png');
%close(h);
end