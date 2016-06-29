%function write_pngs_merged_gt(pathpatients,datasave)

pathpatients='~/Downloads/patient_test/';
for i=1:length(datasave)
    name=datasave{i}{1};
    %pathgt=strcat(pathpatients,name,'/','GT/');
    %mkdir(pathgt);
    vol=merge_labels(datasave,i);
    
%     for k=1:size(vol,3)
%         imwrite(vol(:,:,k),strcat(pathgt,sprintf('%d.png',k)));
%     end
    filecontour=strcat(pathpatients,name,'/','gt.mat');
    save(filecontour,'vol')
    disp(strcat(name,' done'))
    

    

end

%end