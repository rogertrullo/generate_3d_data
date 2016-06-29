
function write_pngs(pathpatients,datasave)

%pathpatients='/home/roger/matlab_toolboxes/import RTstruct/patient_test/'
for i=1:length(datasave)
    name=datasave{i}{1};


    for j=1:size(datasave{i}{4},1)%the organs

        pathgt=strcat(pathpatients,name,'/',datasave{i}{4}{j,1},'/');
        mkdir(pathgt);
        vol=datasave{i}{4}{j,2};
        for k=1:size(vol,3)
            imwrite(vol(:,:,k),strcat(pathgt,sprintf('%d.png',k)));
        end

    end

end

end