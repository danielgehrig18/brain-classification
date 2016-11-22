function [ x ] = MLP2_feature_extract3_ar( path_name, parameters )
%FEATURE_EXTRACT Summary of this function goes here
%   Detailed explanation goes here

% for optimizing reasons (optimize brain after brain, not step after step -
% no need of loading another brain image each for-loop-iteration
imo = nii_read_volume(path_name);

% Reduce image size
im = redImSize(imo,0.3,0.3,0.3);

[x,y,z] = size(im);

% parameters
x_segments = parameters.x_segments; % TODO: optimize parameters
y_segments = parameters.y_segments;
z_segments = parameters.z_segments;

x_regions = floor(x/x_segments *(0:x_segments));
y_regions = floor(y/y_segments *(0:y_segments));
z_regions = floor(z/z_segments *(0:z_segments));

bins = parameters.bins; % TODO: optimize parameter
hbounds = parameters.hbounds;

% Matrix indices start at 1 not 0
x_regions(1) = x_regions(1)+1;
y_regions(1) = y_regions(1)+1;
z_regions(1) = z_regions(1)+1;

% feature vectorML
x = zeros(x_segments*y_segments*z_segments, bins);

% Initzialize count variable
% TODO: optimize speed
count = 1;
for x_i = 1:x_segments
    for y_i=1:y_segments
        for z_i=1:z_segments
            % cut out chunk from image
            chunk = im(x_regions(x_i):x_regions(x_i + 1),...
                       y_regions(y_i):y_regions(y_i + 1),...
                       z_regions(z_i):z_regions(z_i + 1));
            
            
            edges = linspace(hbounds(count,1),hbounds(count,2),bins+1);
            h = histcounts(squeeze(chunk(:)),edges);
            
            x(count, :) = h;
            
            count = count + 1;
        end
    end
end

x = x';
x = x(:)';
end