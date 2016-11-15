function [ feature ] = feature_extract_lab1( path_name, parameters)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Load image
if ischar(path_name)
    im = nii_read_volume(path_name);
    
    xp = parameters.xp;
    yp = parameters.yp;
    zp = parameters.zp;
    lev = parameters.levels;
    movedir = parameters.dir;

    % Reduce image size
    [sim, pixv] = redImSize(im,xp,yp,zp);
    
elseif strcmp(parameters.dir,'all')
    sim = path_name;
    pixv = zeros(3,1);
    pixv(1) = parameters.xp;
    pixv(2) = parameters.yp;
    pixv(3) = parameters.zp;
%     lev = parameters.levels;
    movedir = parameters.dir;

else
    error('Wrong input data: path_name must be string or matrix')
end




% Compute feature
switch movedir
    case 'x'
        feature = zeros(3,pixv(1));
        for i = 1:pixv(1)
            [~,feature(:,i)] = quantgray(squeeze(sim(i,:,:)),lev);
        end
    case 'y'
        feature = zeros(3,pixv(2));
        for i = 1:pixv(2)
            [~,feature(:,i)] = quantgray(squeeze(sim(:,i,:)),lev);
        end
    case 'z'
        feature = zeros(3,pixv(3));
        for i = 1:pixv(3)
            [~,feature(:,i)] = quantgray(squeeze(sim(:,:,i)),lev);
        end
    case 'all'
        f1 = zeros(1,pixv(1));
        for i = 1:pixv(1)
            temp = edge(squeeze(sim(i,:,:)),'prewitt');
            f1(:,i) = sum(temp(:));
        end
        f2 = zeros(1,pixv(2));
        for i = 1:pixv(2)
            temp = edge(squeeze(sim(:,i,:)),'prewitt');
            f2(:,i) = sum(temp(:));
        end
        f3 = zeros(1,pixv(3));
        for i = 1:pixv(3)
            temp = edge(squeeze(sim(:,:,i)),'prewitt');
            f3(:,i) = sum(temp(:));
        end
        NoV = pixv(1)*pixv(2)*pixv(3);
        feature = 1/NoV*(sum(f1,2)+sum(f2,2)+sum(f3,2));
end

if strcmp(parameters.dir,'all') == 0
    feature = [feature(1,:) feature(2,:) feature(3,:)];
end



end

function[rgbim, countlabel] = quantgray(im, levels)

% Compute thresholds according to Otsu's method (Number of thresholds =
% levels)
thresh = multithresh(im,levels);
% Segment the image according to the thresholds
labelim = imquantize(im,thresh);
% Count the voxels in each segment
countlabel = zeros(levels+1,1);
for k = 1:levels+1
    tempcl = labelim == k;
    countlabel(k,1) = sum(tempcl(:));
end
% Create rgb image (each segment is colored differently)
rgbim = label2rgb(labelim);

end

function [ smallIm,pix ] = redImSize( im,xperc,yperc,zperc )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% Reduce the image size, get rid of the black surrounding (tighten the box
% that surrounds the brain)

[x,y,z] = size(im);

% Number of voxels to omit on each side
xpix = floor(xperc*x/2);
ypix = floor(yperc*y/2);
zpix = floor(zperc*z/2);

smallIm = im(xpix+1:end-xpix,ypix+1:end-ypix,zpix+1:end-zpix);

pix = size(smallIm);

end