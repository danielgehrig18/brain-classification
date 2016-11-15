function [ x ] = MLP2_feature_extract2( path_name, parameters )
%FEATURE_EXTRACT Summary of this function goes here
%   Detailed explanation goes here

% for optimizing reasons (optimize brain after brain, not step after step -
% no need of loading another brain image each for loop iteration
im = nii_read_volume(path_name);
[x,y,z] = size(im);

% parameters
x_segments = parameters.x_segments;
y_segments = parameters.y_segments;
z_segments = parameters.z_segments;

x_regions = floor(x/x_segments *(0:x_segments));
y_regions = floor(y/y_segments *(0:y_segments));
z_regions = floor(z/z_segments *(0:z_segments));

bins = parameters.bins;

% Matrix indices start at 1 not 0
x_regions(1) = x_regions(1)+1;
y_regions(1) = y_regions(1)+1;
z_regions(1) = z_regions(1)+1;


% feature vectorML
x = zeros(x_segments*y_segments*z_segments, bins);

% Initzialize count variable
count = 1;
for x_i = 1:x_segments
    for y_i=1:y_segments
        for z_i=1:z_segments
            % cut out chunk from image
            chunk = im(x_regions(x_i):x_regions(x_i + 1),...
                       y_regions(y_i):y_regions(y_i + 1),...
                       z_regions(z_i):z_regions(z_i + 1));
                   
            h = zeros(1,bins);
            for i = 1:size(chunk,3)
                slice = chunk(:,:,i);
                warning('off', 'all');
                [th, m] = multithresh(slice, bins+1);
                warning('on', 'images:multithresh:noConvergence');
                slice(slice == 0) = [];
                h = h + histcounts(slice, th);
            end
            x(count, :) = h;
            
            count = count + 1;
        end
    end
end

x = x';
x = x(:)';
end