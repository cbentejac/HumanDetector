function Silhouette_detector(images_names, threshold, video, video_dir, mask_template)
    % For each frame, do the silouhette detection with the "test" function.     
    for i = 1 : size(images_names, 2)
        aux1 = sprintf('%s/%s/images/%s', video_dir, video, ...
            images_names{i});  
        aux2 = sprintf('%s/%s/masks/%s', video_dir, video, ...
            images_names{i});          
%         aux = sprintf('Video: %s, Frame %d of %d', video, i, ...
%             size(images_names, 2));
%          disp(aux)
        test(aux1, aux2, images_names{i}, threshold, video, video_dir, mask_template, i);    
    end
end

% Function containing our final detector.
function test(name_image, name_mask, image_name, threshold, video, ...
    video_dir, mask_template, num_frame)

    % BLOB DETECTION
    final_blobs = Test_Templates(name_mask, threshold, mask_template);
    
    out_filename = sprintf('%s/%s/%s_Silhouette_%.2f.idl', video_dir, ...
        video, video, threshold);
    if(num_frame == 1)
        fid = fopen(out_filename,'w+');
        fclose(fid);
    end
    save_blobs(final_blobs, name_image, out_filename);
end
    

