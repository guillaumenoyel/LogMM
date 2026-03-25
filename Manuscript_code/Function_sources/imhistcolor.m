%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Colour histograms
%
% imhistcolor( im ) : display the colours histograms
% imhistcolor( im , dim ) : display the colours histograms along one dim
% or
% [ tab_counts , x ] = imhistcolor( im ) : return the counts in COUNTS and the
%   bin locations in X so that stem(X,COUNTS) shows the histogram.
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS  %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im             # colour input image
% dim            # along which dim the histogram are displayed
%                   - 2 (default), horizontal
%                   - 1 : vertical
%                   - 3 superimposed
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% tab_counts     # histogram counts for
%                      - red    : tab_counts(:,1)
%                      - green  : tab_counts(:,2)
%                      - blue   : tab_counts(:,3)
% x              # bin locations in x
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imhistcolor.m
% Guillaume NOYEL 23-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ tab_counts , x ] = imhistcolor( im , dim )

%% Input - Output management

nb_fix_arg = 1;
if nargin == nb_fix_arg
    dim = 2;
end

nb_arg_out_max = 2;

if nargout > 0 && nargout <= nb_arg_out_max
    flag_return_values = true;
else
    flag_return_values = false;
end


if ~flag_return_values
    switch dim
        case 3
            no_subplot_2 = 1;
            no_subplot_1 = 1;        
        case 2
            no_subplot_1 = 1;
            no_subplot_2 = 3;
        case 1
            no_subplot_2 = 1;
            no_subplot_1 = 3;
        otherwise
            error('Bad number of input arguments');
    end
end

isScaled = true;
map = [];
DP = size(im,3);
tab_h = NaN(1,3);
tab_h_p = NaN(1,3);

list_col_name = {'Red','Green','Blue'};
list_col = {'r','g','b'};

for no_col = 1:DP
   [counts,x] = imhist(im(:,:,no_col));
   if no_col==1
       tab_counts = NaN(length(counts),3);
   end
   tab_counts(:,no_col) = counts;
   if ~flag_return_values 
       if dim == 3 % superimposition of the histogram
           hold on;
           bar(x + (no_col-1)*0.33 ,counts,0.33,list_col{no_col});
           %             if no_col ==1
           %                 plot_result(x, counts, map, isScaled, class(im), [0 255], sprintf('-%s',list_col{no_col}),no_col);
           %             else
           %                 stem(x + (no_col-1)*0.33 ,counts, list_col{no_col} , 'Marker', 'none');
           %             end
       else
           tab_h(no_col) = subplot(no_subplot_1,no_subplot_2,no_col);
           plot_result(x, counts, map, isScaled, class(im), [0 255], sprintf('-%s',list_col{no_col}),no_col);
           title(list_col_name{no_col});
       end
   end
end
if ~flag_return_values 
    if dim==3
        ylim([0 prctile(tab_counts(:),99.7)]);
        title('Colour histogram')
    else
        FIG_ajuste_ylim_plusieurs_subplot( tab_h );
    end
end
    
% [counts,x] = imhist(im(:,:,1));
% if ~flag_return_values
%     h_r = subplot(no_subplot_1,no_subplot_2,1);
%     no_col = 1;
%     %v_map_col = 0:1/255:1; v_map_zeros = zeros(1,256);
%     %map = cat(2,v_map_col(:),v_map_zeros(:),v_map_zeros(:));
%     plot_result(x, counts, map, isScaled, class(im), [0 255], '-r',no_col);
%     title('Red')
% else
%     tab_counts = NaN(length(counts),3);
%     tab_counts(:,1) = counts;
% end
% 
% [counts,x] = imhist(im(:,:,2));
% if ~flag_return_values
%     h_g = subplot(no_subplot_1,no_subplot_2,2);
%     no_col = 2;
%     plot_result(x, counts, map, isScaled, class(im), [0 255], '-g',no_col);
%     title('Green')
% else
%     tab_counts(:,2) = counts;
% end
% 
% 
% [counts,x] = imhist(im(:,:,3));
% if ~flag_return_values
%     h_b = subplot(no_subplot_1,no_subplot_2,3);
%     no_col = 3;
%     plot_result(x, counts, map, isScaled, class(im), [0 255], '-b',no_col);
%     title('Blue')
% else
%     tab_counts(:,3) = counts;
% end
% 
% FIG_ajuste_ylim_plusieurs_subplot( [ h_r h_g h_b] );



end


%%%
%%% Function plot_result
%%%
function plot_result(x, y, cm, isScaled, classin, range, color,no_col)

n = length(x);
stem(x,y, color , 'Marker', 'none')
hist_axes = gca;

h_fig = ancestor(hist_axes,'figure');

% Get x/y limits of axes using axis
limits = axis(hist_axes);
if n ~= 1
  limits(1) = min(x);
else
  limits(1) = 0;
end
limits(2) = max(x);
var = sqrt(y'*y/length(y));
limits(4) = 2.5*var;
axis(hist_axes,limits);


% Cache the original axes position so that axes can be repositioned to
% occupy the space used by the colorstripe if nextplot clears the histogram
% axes.
original_axes_pos = get(hist_axes,'Position');

% In GUIDE, default axes units are characters. In order for axes repositiong
% to behave properly, units need to be normalized.
hist_axes_units_old = get(hist_axes,'units');
set(hist_axes,'Units','Normalized');
% Get axis position and make room for color stripe.
pos = get(hist_axes,'pos');
stripe = 0.075;
set(hist_axes,'pos',[pos(1) pos(2)+stripe*pos(4) pos(3) (1-stripe)*pos(4)])
set(hist_axes,'Units',hist_axes_units_old);

set(hist_axes,'xticklabel','')

% Create axis for stripe
stripe_axes = axes('Parent',get(hist_axes,'Parent'),...
                'Position', [pos(1) pos(2) pos(3) stripe*pos(4)]);
				 				 
limits = axis(stripe_axes);

% Create color stripe
if isScaled,
    binInterval = 1/n;
    xdata = [binInterval/2 1-(binInterval/2)];
    limits(1:2) = range;
    switch classin
     case {'uint8', 'uint16', 'uint32'}
        xdata = range(2)*xdata;
        C = (1:n)/n;
     case {'int8','int16', 'int32'}
        xdata = (range(2)-range(1))* xdata + range(1);
        C = (1:n)/n;
     case {'double','single'}
        C = (1:n)/n;
     case 'logical'
        C = [0 1];
     otherwise
        error(message('images:imhist:internalError'))
    end
    
    % image(X,Y,C) where C is the RGB color you specify. 
    %image(xdata,[0 1],repmat(C, [1 1 3]),'Parent',stripe_axes);
    C0 = zeros(size(C));
    switch no_col
        case 1
            image(xdata,[0 1],cat(3,C,C0,C0),'Parent',stripe_axes);
        case 2
            image(xdata,[0 1],cat(3,C0,C,C0),'Parent',stripe_axes);
        case 3
            image(xdata,[0 1],cat(3,C0,C0,C),'Parent',stripe_axes);
    end
    
else
    if length(cm)<=256
        image([1 n],[0 1],1:n,'Parent',stripe_axes); 
        set(h_fig,'Colormap',cm);
        limits(1) = 0.5;
        limits(2) = n + 0.5;
    else
        image([1 n],[0 1],permute(cm, [3 1 2]),'Parent',stripe_axes);
        limits(1) = 0.5;
        limits(2) = n + 0.5;
    end
end

set(stripe_axes,'yticklabel','')
axis(stripe_axes,limits);

% Put a border around the stripe.
line(limits([1 2 2 1 1]),limits([3 3 4 4 3]),...
       'LineStyle','-',...
       'Parent',stripe_axes,...
       'Color',get(stripe_axes,'XColor'));

% Special code for a binary image
if strcmp(classin,'logical')
    % make sure that the stripe's X axis has 0 and 1 as tick marks.
    set(stripe_axes,'XTick',[0 1]);

    % remove unnecessary tick marks from axis showing the histogram
    set(hist_axes,'XTick',0);
    
    % make the histogram lines thicker
    h = get(hist_axes,'children');
    obj = findobj(h,'flat','Color','b');
    lineWidth = 10;
    set(obj,'LineWidth',lineWidth);
end

set(h_fig,'CurrentAxes',hist_axes);

% Tag for testing. 
set(stripe_axes,'tag','colorstripe');

wireHistogramAxesListeners(hist_axes,stripe_axes,original_axes_pos);

% Link the XLim of histogram and color stripe axes together.
% In calls to imhist in a tight loop, the histogram and colorstripe axes
% are destroyed and recreated repetitively. Use linkprop rather than
% linkaxes to link xlimits together to solve deletion timing problems.
h_link = linkprop([hist_axes,stripe_axes],'XLim');
setappdata(stripe_axes,'linkColorStripe',h_link);

end

%%%
%%% Function wireHistogramAxesListeners
%%%
function wireHistogramAxesListeners(hist_axes,stripe_axes,original_axes_pos)

% If the histogram axes is deleted, delete the color stripe associated with
% the histogram axes.
cb_fun = @(obj,evt) removeColorStripeAxes(stripe_axes);
lis.histogramAxesDeletedListener = iptui.iptaddlistener(hist_axes,...
    'ObjectBeingDestroyed',cb_fun);

% This is a dummy hg object used to listen for when the histogram axes is cleared.
deleteProxy = text('Parent',hist_axes,...
    'Visible','Off', ...
    'Tag','axes cleared proxy',...
    'HandleVisibility','off');

% deleteProxy is an invisible text object that is parented to the histogram
% axes.  If the ObjectBeingDestroyed listener fires, the histogram axes has
% been cleared. This listener is triggered by newplot when newplot clears
% the current axes to make way for new hg objects being drawn. This
% listener does NOT fire as a result of the parent axes being deleted.
prox_del_cb = @(obj,evt) histogramAxesCleared(obj,stripe_axes,original_axes_pos);
lis.proxydeleted = iptui.iptaddlistener(deleteProxy,...
    'ObjectBeingDestroyed',prox_del_cb);

setappdata(stripe_axes,'ColorStripeListeners',lis);

end

%%%
%%% Function removeColorStripeAxes
%%%
function removeColorStripeAxes(stripe_axes)

if ishghandle(stripe_axes)
    delete(stripe_axes);
end
end        

%%%
%%% Function histogramAxesCleared
%%%
function histogramAxesCleared(hDeleteProxy,stripe_axes,original_axes_pos)

removeColorStripeAxes(stripe_axes);

h_hist_ax = get(hDeleteProxy,'parent');
set(h_hist_ax,'Position',original_axes_pos);
end
