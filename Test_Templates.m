function final_blobs = Test_Templates(name_mask, threshold, mask_template)

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % PART 1: OBJECT EXTRACTION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Extracts the objects by isolating the components. Very small
    % objects have already been eliminated.
    % We're doing it here since we need to extract the objects only
    % once per frame and not every single time we're switching
    % templates.
    mask_test = imread(name_mask);
    cc = bwconncomp(mask_test);
    stats = regionprops(cc, 'BoundingBox');
    area = regionprops(cc, 'Area');
    final_blobs = [];

    %%Object classification code
    %%Code to change   
    for l = 1 : length(stats)
        x1 = floor(stats(l).BoundingBox(2));
        y1 = floor(stats(l).BoundingBox(1));
        height = floor(stats(l).BoundingBox(3));
        width = floor(stats(l).BoundingBox(4));
                
        area_object = area(l).Area(1) / (height * width);
        bool_area = area_object > 0.1 && area_object < 0.85;
              
        if x1 <= 0
            x1 = 1;
        end
        if y1 <= 0
            y1 = 1;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % % % PART 2: SILOUHETTE MATCHING & CONFIDENCE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if width >= 30 && height >= 30 && bool_area               
                
                template = mask_template / sum(sum(mask_template));
                mask = mask_test;
                % Gets the extrema of the correlation between the template 
                % and the object (and handles the case where the
                % coordinates are 0, since we're in MATLAB).
                correlation = filter2(mask(x1 : x1 + width, ...
                    y1 : y1 + height), template);
                xymax = max(max(correlation));

                confidence(l) = xymax;
            
        else
            confidence(l) = 0;
        end

    end
    %%%Object classification code
    %%Code to change          

    %%%People detector output blobs format according to test_DTDP_detector.m from Session1
    %%Code to change 
    if isempty(stats) == 0
        for l = 1 : length(stats)
            final_confidence = confidence(l); 
            x1 = floor(stats(l).BoundingBox(1));
            x2 = x1 + floor(stats(l).BoundingBox(3));
            y1 = floor(stats(l).BoundingBox(2));
            y2 = y1 + floor(stats(l).BoundingBox(4));

            if x1 <= 0
                x1 = 1;
            end
            if x2 > size(mask_test, 2)
                x2 = size(mask_test, 2);
            end
            if y1 <= 0
                y1 = 1;
            end
            if y2 > size(mask_test, 1)
                y2 = size(mask_test, 1);
            end
            final_blobs(end + 1, :) = [x1, y1, x2, y2, final_confidence]; 
        end
    
        % Drops the blobs whose confidence value is below a threhsold.         
        thresholding = final_blobs(:, 5) > threshold;
        final_blobs = final_blobs(thresholding, :);
        % Sorts the final blobs for this frame depending on the confidence.
        [~, I] = sort(final_blobs(:, 5), 'descend');
        final_blobs = final_blobs(I, :);
        
        %%%People detector output blobs format according to test_DTDP_detector.m from Session1
        %%Code to change       
    end
end  
