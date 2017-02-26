function Silhouette_detector(images_names,threshold,video,video_dir)
    % For each frame, do the silouhette detection with the "test" function.     
    for i=1:size(images_names,2)
        aux1=sprintf('%s/%s/images/%s',video_dir,video,images_names{i});  
        aux2=sprintf('%s/%s/masks/%s',video_dir,video,images_names{i});          
        aux=sprintf('Video: %s, Frame %d of %d',video,i,size(images_names,2));
        disp(aux)
        test(aux1,aux2, images_names{i},threshold,video,video_dir,i);    
    end
end



% Function containing our final detector.
function test(name_image,name_mask, image_name,threshold,video,video_dir,num_frame)

    final_blobs=[];
    
    %%%Final detector
    %%Code to change    
    %%Your detector
    
    %% TEMPLATE PROCESSING
    % Gets the templates from a directory in which they have been
    % pre-computed. 
%     Extract_Templates(video_dir, video);
    
    
    %% BLOB DETECTION
    % Does the same thing as in the "Extract_Templates" script: finds all
    % the blobs in one picture, uses the codebook to get the correlation
    % between those objects and the templates, gets a confidence value out
    % of it and writes it into a file (named
    % "SequenceX_Silhouette_threshold) which will later be read.
    
    
    
    % final_blobs fromat example: Session 1 test_DTDP_Detector in order from the
    % higest score to the lowest one
    % final_blobs=[70.4281  158.8926  150.0303  421.8818    1.0296;
    %              210.2631  198.7211  253.6652  347.2814    0.3323;
    %              407.5838  182.9884  477.8997  410.3730   -0.2838;
    %              134.1665  193.4742  194.9127  374.1023   -0.3597;
    %              280.6267  178.8918  346.4894  389.6681   -0.4079;
    %              ....];
    %Dummy/example:
    final_blobs=[50 50 100 230 0.9;
                 40 40 140 100 0.85;
                 70 80 120 120 0.71;
                 20 90 170 220 0.6;
                 60 10 10 20 0.3;
                 90 20 200 200 0.11];
    %%%Final detector
    %%Code to change    
 
    
   
    out_filename=sprintf('%s/%s/%s_Silhouette_%.2f.idl',video_dir,video,video,threshold);
    if(num_frame==1)
        fid=fopen(out_filename,'w+');
        fclose(fid);
    end
    save_blobs(final_blobs,name_image,out_filename);
end
    

