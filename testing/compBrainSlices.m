% Compare several slices of sick and healthy brains

addpath('../ReadData3D_version1k/nii')

V_1 = nii_read_volume('../data/set_train/train_103.nii');   % sick
V_2 = nii_read_volume('../data/set_train/train_158.nii');  % sick
% V_2 = nii_read_volume('../data/set_train/train_153.nii');   % not sick
% V_2 = nii_read_volume('../data/set_train/train_208.nii');  % not sick


% Reduce image size
xperc = 0.3;
yperc = 0.3;
zperc = 0.3;
V_1r = redImSize(V_1,xperc,yperc,zperc);
V_2r = redImSize(V_2,xperc,yperc,zperc);

% Choose axis to move along
[x,y,z] = size(V_1r);
slices = 16;
NoS = floor(z/slices);
axdir = 'z';
thresh = 0.2;

close all

for i = 6       %1:NoS
    % Select 16 slices
    Im1 = slice16(V_1r,i,axdir,thresh);
    Im2 = slice16(V_2r,i,axdir,thresh);
    
    % Make unit8 greyscale
%     Im1 = uint8(Im1)*255;
%     Im2 = uint8(Im2)*255;
    
    figure(1)
    imshow(Im1,[])
    title('Sick Brain')
    
    figure(2)
    imshow(Im2,[])
    title('Healthy Brain')
    
    % Wait for button press
%     pause(5)
    
end