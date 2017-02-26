function templates_directory = Extract_Templates(video_dir, videos)
    % Selects the folders of the input videos & creates "Templates_train".  
    templates_directory = '.\Templates_train';
    mkdir Templates_train;

    % Initializes the counter of templates (will be used to name the 
    % templates that are going to be written out).
    num_templates = 0;
    for i = 1 : size(videos,2)    
        dir = sprintf('cd ''%s''',pwd); % Gets our current path (+ cd).
        directory_masks = sprintf('cd %s/%s/masks/', video_dir, ...
            videos{i}); % Gets the masks' paths (+ cd).
        eval(directory_masks);
        number_masks = ls;    
        eval (dir) 

        for j = 3 : size(number_masks, 1)        
            % Gets the name of the mask to read and loads/reads it.
            name_mask = sprintf('%s/%s/masks/frame%.4d.png', ...
                video_dir, videos{i}, j - 3);
            mask = imread(name_mask);

            %%%Object extraction code
            %%Code to change
            cc = bwconncomp(mask);
            stats = regionprops(cc, 'BoundingBox');
            area = regionprops(cc, 'Area');

            max_size = 0;
            max_k = -1;

            if ~(isempty(stats))
                for k = 1 : length(stats)

                    height = stats(k).BoundingBox(3);
                    width = stats(k).BoundingBox(4);

                    % Basically, looks for the biggest component, assumes 
                    % it's a body if it's bigger than 30 * 30 pixels (but 
                    % could literally be anything, as long as it's big 
                    % enough) and crops around it.
                    if area(k).Area > max_size && ...
                            (width >= 30 && height >= 30)
                        max_size = area(k).Area;
                        max_k = k;
                    end
                end
               
                % If one blob was deemed worthy of becoming a template,
                % crops the image around it and saves it. Else, do nothing
                % (and thus don't try to extract a template at all).
                if max_k > -1
                    x1 = floor(stats(max_k).BoundingBox(2));
                    y1 = floor(stats(max_k).BoundingBox(1));
                    x2 = round(x1 + stats(max_k).BoundingBox(4));
                    y2 = round(y1 + stats(max_k).BoundingBox(3));

                    % Handles the cases where the object extraction code 
                    % would set out-of-image boundaries.         
                    if x1 <= 0
                        x1 = 1;
                    end
                    if y1 <= 0
                        y1 = 1;
                    end
                    if x2 > size(mask, 1)
                        x2 = size(mask, 1);
                    end
                    if y2 > size(mask, 2)
                        y2 = size(mask, 2);
                    end
                    crop_image = mask(x1 : x2, y1 : y2); % Crops the image.
                    
                    % Saves the template in the directory created for it.
                    num_templates = num_templates + 1; % Increases counter.
                    template_name = sprintf('%s/template%.4d.png', ...
                        templates_directory, num_templates);
                    imwrite(crop_image, template_name) % Saves the template.
                end
            %%Code to change
            %%%Object extraction code   
            end   
        end
        disp([num2str(videos{i}), ' done, ', num2str(num_templates), ...
            ' templates extracted in total.']);
    end
end