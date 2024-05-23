classdef plotobj
    properties
        fig_nbr = 2;
        clear_figure = true;
        
        % Cells
        N_row       % Number of row is subplot grid
        N_col       % Number of columns is subplot grid
        Cell_position        % Normalized position for each subplot cell
        ax       % Axes handles for the figure
        
        % Margins
        margins_left = .075;
        margins_bottom = .075;
        margins_right =  .05;
        margins_top = .05; %default .025
        
        % Gaps
        gap_row = .05;
        gap_col = .05;       
        
        % Dimensions
        fig_width = 1;  % Normalized complete figure width
        fig_height = 1; % Normalized complete figure height
        plot_width  % Normalized width of plottable area
        plot_height % Normalized height of plottable area
        subplot_width % Normalized width of plot cell area
        subplot_height % Normalized height of plot cell area
    end
    
    methods
        function obj = plotobj(varargin)
            fprintf('plotobj has been replaced by FIG. Consider using newer version of code.')
            % Define plotobj as obj = plotobj(fignumber,[Nrow,Ncol],varargin)
            obj.fig_nbr = varargin{1};
            ii=2;
            
            % Assign subplot grid dimensions
            if nargin > 1
                obj.N_row = varargin{2}(1);
                obj.N_col = varargin{2}(2);
                ii = 3;
            else    % Make an varargin{2}*varargin{2} grid
                obj.N_row = varargin{2};
                obj.N_row = varargin{2};
            end
            
            % If you want to define the margins, argin{ii} should be
            % 'Margins' and argin{ii+1} [left,bottom,right,top]
            if nargin > 2 && ischar(varargin{ii})
                if strcmp(varargin{ii},'Margins')
                    obj.margins_left = varargin{ii+1}(1);
                    obj.margins_bottom = varargin{ii+1}(2);
                    obj.margins_right = varargin{ii+1}(3);
                    obj.margins_top = varargin{ii+1}(4);
                    ii=ii+2;
                end
            end
                      
            % If you want to define the gaps, argin{ii} should be
            % 'Gaps' and argin{ii+1} [left,bottom,right,top]
            if nargin > 2 && ischar(varargin{ii})
                if strcmp(varargin{ii},'Gaps')
                obj.gap_row = varargin{ii+1}(1);
                obj.gap_col = varargin{ii+1}(2);
                ii=ii+2;
                end
            end

            % Dimensions
            obj.plot_width = obj.fig_width - obj.margins_left - obj.margins_right;  %Normalized width of plottable area
            obj.plot_height = obj.fig_height - obj.margins_top - obj.margins_bottom; %Normalized height of plottable area
            obj.subplot_width = (obj.plot_width - (obj.N_col-1)*obj.gap_col)/obj.N_col; %Normalized width of subplot area
            obj.subplot_height = (obj.plot_height - (obj.N_row-1)*obj.gap_row)/obj.N_row; %Normalized height of subplot area
            
            figure(obj.fig_nbr), if obj.clear_figure,clf(obj.fig_nbr),end
            nfig = 0;
            
            % Create individual axes
            if ii > length(varargin)
                nfigtot = obj.N_row*obj.N_col;
                iisp = 1;
                while iisp <= nfigtot
                    nfig = nfig+1;
                    i_subplot = iisp;
                    i_subplot_min = iisp;
                    i_subplot_max = iisp;
                    
                    i_cols = rem(i_subplot-1,obj.N_col); % Columns of each tiles
                    ncol_subplot = max(i_cols)-min(i_cols)+1;
                    i_rows = floor(abs(i_subplot-1)/obj.N_col);
                    nrow_subplot = max(i_rows)-min(i_rows)+1;

                    % Save position
                    obj.Cell_position(nfig,1:4) = [obj.margins_left+(rem(i_subplot_min-1,obj.N_col))*(obj.subplot_width+obj.gap_col) ...
                                1-obj.margins_top-obj.subplot_height-(floor(abs(i_subplot_max-1)/obj.N_col))*(obj.subplot_height+obj.gap_row)...
                                ncol_subplot*obj.subplot_width+(ncol_subplot-1)*obj.gap_col...
                                nrow_subplot*obj.subplot_height+(nrow_subplot-1)*obj.gap_row];

                    % Create axes
                    ax(nfig) = axes('Position',[obj.margins_left+(rem(i_subplot_min-1,obj.N_col))*(obj.subplot_width+obj.gap_col) ...
                                1-obj.margins_top-obj.subplot_height-(floor(abs(i_subplot_max-1)/obj.N_col))*(obj.subplot_height+obj.gap_row)...
                                ncol_subplot*obj.subplot_width+(ncol_subplot-1)*obj.gap_col...
                                nrow_subplot*obj.subplot_height+(nrow_subplot-1)*obj.gap_row],...
                                'NextPlot','add');
                    box on
                    iisp = iisp+1;
                end
            else
                while ii <= length(varargin)
                    i_subplot = str2double(varargin{ii});
                    nfig = nfig+1;
                    i_subplot_min = i_subplot(1);
                    i_subplot_max = i_subplot(end);

                    i_cols = rem(i_subplot-1,obj.N_col); % Columns of each tiles
                    ncol_subplot = max(i_cols)-min(i_cols)+1;
                    i_rows = floor(abs(i_subplot-1)/obj.N_col);
                    nrow_subplot = max(i_rows)-min(i_rows)+1;

                    % Save position
                    obj.Cell_position(nfig,1:4) = [obj.margins_left+(rem(i_subplot_min-1,obj.N_col))*(obj.subplot_width+obj.gap_col) ...
                                1-obj.margins_top-obj.subplot_height-(floor(abs(i_subplot_max-1)/obj.N_col))*(obj.subplot_height+obj.gap_row)...
                                ncol_subplot*obj.subplot_width+(ncol_subplot-1)*obj.gap_col...
                                nrow_subplot*obj.subplot_height+(nrow_subplot-1)*obj.gap_row];

                    % Create axes
                    ax(nfig) = axes('Position',[obj.margins_left+(rem(i_subplot_min-1,obj.N_col))*(obj.subplot_width+obj.gap_col) ...
                                1-obj.margins_top-obj.subplot_height-(floor(abs(i_subplot_max-1)/obj.N_col))*(obj.subplot_height+obj.gap_row)...
                                ncol_subplot*obj.subplot_width+(ncol_subplot-1)*obj.gap_col...
                                nrow_subplot*obj.subplot_height+(nrow_subplot-1)*obj.gap_row]);
                    box on
                    ii = ii+1;
                end 
            end
            obj.ax = ax;
        end
        function makeidentifier(obj,varargin)
            alphabet = 'abcdefghijklmnopqrstuvwxyz';    % Define alphabet string for figure numbering
            if length(varargin)-1 == 0 %No position given
                pos = [0.015,0.95];
            elseif length(varargin)-1 == 1  %Same position for all plots
                if strcmp(varargin{2},'NorthEast')
                    pos = [0.875,0.925]; 
                elseif strcmp(varargin{2},'NorthWest')
                    pos = [0.025,0.925];   
                elseif strcmp(varargin{2},'NorthEast2')
                    pos = [0.875,0.85];   
                elseif strcmp(varargin{2},'SouthEast')
                    pos = [0.85,0.095]; 
                elseif strcmp(varargin{2},'SouthWest')
                    pos = [0.05,0.05];
                elseif strcmp(varargin{2},'NorthWestOutside')
                    pos = [-0.1,1.1];
                end
                for i = 1:length(obj.ax)
                    axes(obj.ax(i))
                    text(pos(1),pos(2), ['(' alphabet(i) ')'],'Units','normalized');
                end
            elseif length(varargin)-1 == length(obj.ax) %Plot specific positions
                ii = 2; % Skip first vararing entry
                while ii-1<=length(obj.ax)
                    % Determine position of identifier
                    if strcmp(varargin{ii},'NorthEast')
                        pos = [0.925,0.925]; 
                    elseif strcmp(varargin{ii},'NorthEast3')   % NorthEast when 3 plots are plotted on each row
                        pos = [0.78,0.925];
                    elseif strcmp(varargin{ii},'NorthWest')
                        pos = [0.025,0.925];    
                    elseif strcmp(varargin{ii},'SouthEast')
                        pos = [0.925,0.095]; 
                    elseif strcmp(varargin{ii},'SouthWest')
                        pos = [0.05,0.15];
                    end
                    % Make identifer
                    axes(obj.ax(ii-1))
                    text(pos(1),pos(2), ['(' alphabet(ii-1) ')'],'Units','normalized'); 
                    %Increment
                    ii = ii+1;
                end
            end
        end  
        function sax(obj,iax,varargin)
            axes(obj.ax(iax))
            hold on, box on
            legend show
            if nargin<2
            grid on, grid minor
            end
        end
        function pos_legend(obj,iax,pos)
            axes(obj.ax(iax))
            h = gca;
            l = h.Legend;
            lpos = l.Position;
            switch pos
                case 'northeastoutside'
                    set(h.Legend,'Position',[1-obj.margins_right+0.05, 0.5 ,lpos(3), lpos(4)])
                case 'northwestoutside'
                    set(h.Legend,'Position',[obj.margins_left,1-obj.margins_top+0.05 ,lpos(3), lpos(4)])
            end
        end
        function position(obj,x0,y0,width,height,units)
             set(gcf,'Position',[x0,y0 width height],'Units',units)           
        end
    end
end