function save_blobs(final_blobs,image_name,out_filename);

fid=fopen(out_filename,'a+');
for i=1:size(final_blobs,1)    
    if size(final_blobs,1)==1
        fprintf(fid,'"%s"; (%d, %d, %d, %d):%.4f;\n',image_name, round(final_blobs(i,1)), round(final_blobs(i,2)), round(final_blobs(i,3)), round(final_blobs(i,4)), final_blobs(i,5));
    elseif i==1
        fprintf(fid,'"%s"; (%d, %d, %d, %d):%.4f,',image_name, round(final_blobs(i,1)), round(final_blobs(i,2)), round(final_blobs(i,3)), round(final_blobs(i,4)), final_blobs(i,5));
    elseif i<size(final_blobs,1)
        fprintf(fid,' (%d, %d, %d, %d):%.4f,',round(final_blobs(i,1)), round(final_blobs(i,2)), round(final_blobs(i,3)), round(final_blobs(i,4)), final_blobs(i,5));        
    else
        fprintf(fid,' (%d, %d, %d, %d):%.4f;\n',round(final_blobs(i,1)), round(final_blobs(i,2)), round(final_blobs(i,3)), round(final_blobs(i,4)), final_blobs(i,5));        
    end
end
if(size(final_blobs,1)==0)
    fprintf(fid,'"%s";\n',image_name);
end
fclose(fid);