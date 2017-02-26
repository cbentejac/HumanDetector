% close all
% clear all
% clc

% Selects the folders of the input videos/templates and creates "Templates_test".  
video_dir='./Videos';
templates_directory='Templates_train';
final_templates_directory='.\Templates_test';
mkdir Templates_test;

% Creates the path changes command and gets the names of the masks.
dir=sprintf('cd ''%s''',pwd);
templates_dir=sprintf('cd %s/',templates_directory);
eval(templates_dir);
number_masks=ls;
eval (dir);
ratio_values=[];

% Selects the useful templates.
 %%%Object extraction code
 %%Code to change    
 
% Selection of the templates based on their size difference:
% Assumption: if the size of two consecutive templates is different enough,
% then the poses of the two silouhettes are different enough to be useful
% and thus selected. 
% 5 pixels has been chosen arbitrarily and seems to be producing
% significant template extraction, but tests will need to be run to assess
% it. (on another hand, a quick look has been given to standard deviation
% and mean but same: tests with a "finished" detector are needed to be able
% to really get the significant templates out in the codebook).
chosen_templates = [];
size_cur = [0 0];
for j=3:size(number_masks, 1)      
    name_mask = sprintf('%s/template%.4d.png', templates_directory, j - 2);
    mask = imread(name_mask);
    
    size_tmp = size(mask);
    if abs(size_tmp(1) - size_cur(1)) > 5 || abs(size_tmp(2) - size_cur(2)) > 5
        chosen_templates(end + 1) = j - 2;
    end
    size_cur = size_tmp;
end    
disp(length(chosen_templates));
%     index=1:size(number_masks,1)-2;
%     N=100;%percentaje
%     step=size(index,2)/(size(index,2)*N/100);
%     chosen_templates=index(1:step:size(index,2));
 
 %%%Object extraction code
 %%Code to change  
    
% Reads in the selected templates, writes them into the test folder and also 
% writes their flip.
num_templates=0;
for n=1:size(chosen_templates,2)
    num_templates=num_templates+1;
    name_mask=sprintf('%s/template%.4d.png',templates_directory,chosen_templates(n));
    mask=imread(name_mask);
    template_name=sprintf('%s/template%.4d.png',final_templates_directory,num_templates);
    imwrite(mask,template_name)
    num_templates=num_templates+1;
    template_name=sprintf('%s/template%.4d.png',final_templates_directory,num_templates);
    imwrite(fliplr(mask),template_name)
end

    