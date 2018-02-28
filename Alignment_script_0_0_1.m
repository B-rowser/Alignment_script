%loadstoolbox


cd C:\Users\ScharfLab\Downloads\IAT_v0.9.2
iat_setup ('FOREVER');

addpath ('C:\Program Files\MATLAB\altmany-export_fig-a0f8ec3')
%This part takes the path the user provides and use it as a template

display ('Please select the template image')
template_path = uigetfile
template_image = imread(template_path);



%This section chooses a folder to pull images from.
display ('Please select the folder containing your images') 
img_folder = uigetdir;
cd (img_folder) 



%Some setup stuff for image alignment
par.transform = 'euclidean'; 
par.levels = 5;
par.iterations = 20; %iterations per level

%Iterates through folder 


my_imgs = dir(fullfile(img_folder,'*.tif'))
for k =1:length(my_imgs) 
     Base_filename = my_imgs(k).name;
     Full_filename = fullfile(img_folder,Base_filename);
     fprintf(1,'Now Processing %s\n', Full_filename);
     Pending_image = imread(Full_filename);
     ECCWarp = iat_ecc(Pending_image, template_image, par);
     [M,N,C] = size(template_image);
     [wimECC, suportECC] = iat_inverse_warping(Pending_image, ECCWarp, par.transform, 1:N, 1:M);
     test_expo = figure; imshow(uint8(wimECC))
     export_fig (sprintf('Image%d', k),  '-tif');

     
end

figure;imshow(template_image)

fprintf(1,'Image alignment complete\n')

