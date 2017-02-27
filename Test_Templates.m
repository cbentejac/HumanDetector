function final_blobs = Test_Templates(name_mask)

    templates_directory='Templates_test';

    % Creates the corresponsing cd commands.
    dir=sprintf('cd ''%s''',pwd);
    templates_dir=sprintf('cd %s/',templates_directory);
    eval(templates_dir);
    number_templates=ls;
    eval (dir);

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
                
        if x1 <= 0
            x1 = 1;
        end
        if y1 <= 0
            y1 = 1;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % % % PART 2: SILOUHETTE MATCHING & CONFIDENCE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ~(width < 30 || height < 30)
            for k = 3 : size(number_templates, 1)
                name_template = sprintf('%s/template%.4d.png', templates_directory, k - 2);
                mask_template = imread(name_template);
                
                template = mask_template / sum(sum(mask_template));
               
                % Gets the extrema of the correlation between the template 
                % and the object (and handles the case where the
                % coordinates are 0, since we're in MATLAB).
                correlation = filter2(mask_test(x1 : x1 + width, y1 : y1 + height), template);
                xymax = extrema2(correlation);

                % Store the maxima for the correlation between each
                % template and the current object.
                if ~(isempty(xymax))
                    confidence(l, k - 2) = max(xymax);
                else
                    confidence(l, k - 2) = 0;
                end 
            end
        else
            confidence(l, :) = 0;
        end

    end
    %%%Object classification code
    %%Code to change          

    %%%People detector output blobs format according to test_DTDP_detector.m from Session1
    %%Code to change 
    if length(stats) ~= 0
        for l = 1 : length(stats)
            final_confidence = max(confidence(l, :)); 
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
    
        % Sorts the final blobs for this frame depending on the confidence.
        [Y, I] = sort(final_blobs(:, 5), 'descend');
        final_blobs = final_blobs(I, :);
        %%%People detector output blobs format according to test_DTDP_detector.m from Session1
        %%Code to change       
    end
end  
