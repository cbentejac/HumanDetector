clear all
close all
clc
threshold = 0.1;
% Gets the path of the video sequences. 
video_dir = './Videos';
video_names = {'Sequence1', 'Sequence2', 'Sequence3', 'Sequence4', ...
    'Sequence5', 'Sequence6', 'Sequence7'};

% templates_directory = Extract_Templates(video_dir, video_names);
% Process_Templates(templates_directory);
str = datestr(now);
% For each video sequence, gets the frames' name and run the silouhette 
% detector for all the frames of that sequence.
for i = 1 : size(video_names, 2)
    video_list = sprintf('%s/%s/images/%slist.txt', video_dir, ...
        video_names{i}, video_names{i});
    fid = fopen(video_list, 'r');
    num_images = 0;
    cadena = fgets(fid);
    images_names = {};
    while(size(cadena, 2) > 4)
        num_images = num_images + 1;
        index = find((cadena == ' ' | cadena == char(13)) == 1);
        if(~isempty(index))
            images_names{num_images} = cadena(1 : index(1) - 1);
        else
            images_names{num_images} = cadena(1 : end - 1);
        end
        cadena = fgets(fid);

    end
    fclose(fid);    
    Silhouette_detector(images_names, threshold, video_names{i}, video_dir);  
end
disp(str);
disp(datestr(now));