%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert an Image object (Image_in.CData) into an RGB image with the corresponding map
%
% [im_RGB , im_RGB_uint8] = ImageObject_to_RGB( Image_in )
% [im_RGB , im_RGB_uint8] = ImageObject_to_RGB( Image_in , clim , cmap )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
% Image_in      # Image object
% clim          # (option) Minimum and maximum of the colours. 
%                   Default clim = [min(Image_in.CData(:)) max(Image_in.CData(:))];
%                           clim can be equal to [] in order to have the
%                           default value
% cmap           # (option) colour map. Default cmap = colormap
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
% im_RGB        # colour image with values in 0 1
% im_RGB_uint8  # colour image with values in uint8 lying in 0 255
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%EXAMPLE%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% Image_in = imagesc(im)
% imwrite( ImageObject_to_RGB(Image_in) , 'im.png' );
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add_colour_mask.m
% Guillaume NOYEL 12/10/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [im_RGB , im_RGB_uint8] = ImageObject_to_RGB( Image_in , varargin )

%% Default arguments


%% Parse inputs
[Image_in , clim , cmap] = ParseInputs( Image_in , varargin{:} );



%% Programme

% make it into an index image.
cmin            = double(clim(1));
cmax            = double(clim(2));
Image_in.CData  = double(Image_in.CData);
if cmax==Inf % if the maximal value is equal to infinity
   mask_inf = Image_in.CData == Inf;
   cmax = max(Image_in.CData(~mask_inf));
   Image_in.CData(mask_inf) = cmax;
end
if cmin==-Inf % if the minimal value is equal to -infinity
   mask_inf = Image_in.CData == -Inf;
   cmin = min(Image_in.CData(~mask_inf));
   Image_in.CData(mask_inf) = cmin;
end
m               = length(cmap);
if strcmp( Image_in.CDataMapping , 'scaled' )
    im_RGB          = ind2rgb(fix((Image_in.CData-cmin)/(cmax-cmin)*m)+1,cmap);
else
    im_RGB          = ind2rgb(fix(Image_in.CData),cmap);
end

im_RGB_uint8    = uint8(im_RGB*255);

        
end

%% ParseInputs

function [Image_in , clim , cmap] = ParseInputs( Image_in , varargin )

p              = inputParser;
default_clim   = [min(Image_in.CData(:)) max(Image_in.CData(:))];
default_cmap   = colormap();
%expectedflag_contrast   = [1 2 3];

addRequired(p,'Image_in',@(x) isa(x,'matlab.graphics.primitive.Image'));
addOptional(p,'clim',default_clim,@(x) (isvector(x) && (length(x) == 2)) || isempty(x) );
addOptional(p,'cmap',default_cmap,@(x) ismatrix(x) && (size(x,2) == 3));

parse( p , Image_in , varargin{:} );
clim           = p.Results.clim;
if isempty(clim)
    clim = default_clim;
end
cmap           = p.Results.cmap;

end
