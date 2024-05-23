classdef FIG
% Explanation goes here
% 


% Author: Thomas Bosman 
% Date:   Nov - 2020 (created)
%         May - 2024 (re-factored)
properties
    % Figure properties
    fig                     % Figure object;
    fig_nbr         = 101;
    clear_figure    = true;
    fig_width       = 1;    % Normalized complete figure width
    fig_height      = 1;    % Normalized complete figure height
    plot_width              % Normalized width of plottable area
    plot_height             % Normalized height of plottable area

    % External margins
    margins_left
    margins_bottom
    margins_right
    margins_top

    % Distances between axes
    gap_row
    gap_col

    % Axes properties
    N_row       % Number of row in axes grid
    N_col       % Number of col in axes grid
    ax          % Collection of all the axes objects
end

methods
    % ----- Constructor ---------------------------------------------------
    function obj = plotobj(fig_nbr,axes_grid,varargin,opt)
        arguments
            fig_nbr
            axes_grid
        end
        arguments (Repeating)
            varargin
        end
        arguments
            opt.left_margin     (1,1) {mustBeNumeric} = [.05]
            opt.bottom_margin   (1,1) {mustBeNumeric} = [.05]
            opt.right_margin    (1,1) {mustBeNumeric} = [.05]
            opt.top_margin      (1,1) {mustBeNumeric} = [.025]
            opt.gap_row = 0.05
            opt.gap_col = 0.05
        end

        % Define figure number
        obj.fig_nbr = fig_nbr;

        % Define axes grid
        obj.N_row = axes_grid(1);
        obj.N_col = axes_grid(2);

        % Adjust margins
        obj.margins_left    = opt.left_margin;
        obj.margins_bottom  = opt.bottom_margin;
        obj.margins_right   = opt.right_margin;
        obj.margins_top     = opt.top_margin;

        % Define plottable area
        obj.plot_width  = obj.fig_width  - obj.margins_left - obj.margins_right;  %Normalized width of plottable area
        obj.plot_height = obj.fig_height - obj.margins_top  - obj.margins_bottom; %Normalized height of plottable area
        
        % Define gap between rows
        switch numel(opt.gap_row)
            case 1
                obj.gap_row = repmat(opt.gap_row,1,max(1,obj.N_row-1));
            case obj.N_row-1
                obj.gap_row = opt.gap_row;
        end
        
        % Define gap between columns
        switch numel(opt.gap_col)
            case 1
                obj.gap_col = repmat(opt.gap_col,1,max(1,obj.N_col-1));
            case obj.N_col-1
                obj.gap_col = opt.gap_col;
        end

        % Calculate axes height & width
        ax_width    = (obj.plot_width  - sum(obj.gap_col))/obj.N_col;
        ax_height   = (obj.plot_height - sum(obj.gap_row))/obj.N_row;

        % Create figure
        obj.fig = figure(obj.fig_nbr); if obj.clear_figure, clf(obj.fig_nbr), end
        
        % Build full grid if no grid has been specified
        if numel(varargin) == 0 % Build full grid
            varargin = num2cell(1:obj.N_row*obj.N_col);
        end

        % Build axes grid
        for i = 1:length(varargin)
            iax = varargin{i};
            
            % Determine min and max index on the grid
            iax_min = iax(1);
            iax_max = iax(end);

            % Determine columns and rows that each axes spans
            i_cols = rem(iax-1,obj.N_col); % Columns of each tiles
            i_rows = floor(abs(iax-1)/obj.N_col);
            n_cols = max(i_cols)-min(i_cols)+1;   % Number of col this axes spans
            n_rows = max(i_rows)-min(i_rows)+1;   % Number of row this axes spans
            
            % Calculate axes position
            pax_left    = obj.margins_left+(rem(iax_min-1,obj.N_col))*(ax_width)+sum(obj.gap_col([1:min(i_cols)]));
            pax_bottom  = 1-obj.margins_top-ax_height-(floor(abs(iax_max-1)/obj.N_col))*(ax_height)-sum(obj.gap_row([1:i_rows(end)]));
            pax_width   = n_cols*ax_width +sum(obj.gap_col([i_cols(1)+1:n_cols-1]));
            pax_height  = n_rows*ax_height+sum(obj.gap_row([i_rows(1)+1:n_rows-1]));

            % Create axes
            ax(i) = axes('Position',[pax_left,pax_bottom,pax_width,pax_height],...
                           'NextPlot','add','Box','on','XGrid','on','YGrid','on');
        end
        obj.ax = ax;       
    end
    
    % ----- Exporter ------------------------------------------------------
    function export(obj)

    end

    % ----- Add identifier ------------------------------------------------
    function add_identifier(obj,opt)
        arguments
            obj
            opt.position = [0.875 0.9]
            opt.position_change = []
        end
        % Define number of axes to add identifier to
        Nax = length(obj.ax);

        % Define alphabet string for figure numbering
        alphabet = 'abcdefghijklmnopqrstuvwxyz';    % Define alphabet string for figure numbering
        
        if isstring(opt.position) || ischar(opt.position)
            switch opt.position
                case 'NorthEast'
                    identifier_position = [0.875,0.925];
            end
        else 
            identifier_position = opt.position;
        end

        % Create grid of position
        identifier_position = repmat(identifier_position,Nax,1);

        % Update certain positions if required
        for i = 1:size(opt.position_change,1)
            identifier_position(opt.position_change(i,1),[1:2]) = opt.position_change(i,[2:3]);
        end

        % Add identifier to axes
        for i = 1:Nax
            text(obj.ax(i),identifier_position(i,1),identifier_position(i,2),...
                    ['(' alphabet(i) ')'],'Units','normalized');
        end
    end
end

end