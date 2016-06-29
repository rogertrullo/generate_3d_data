pathpatients='/Users/trullro/Downloads/patient_test/'

for i=1:length(datasave)
    name=datasave{i}{1};


    for j=1:size(datasave{i}{4},1)%the organs

        filecontour=strcat(pathpatients,name,'/','contour.mat');
        vol=datasave{i}{4}{j,2};
        save(filecontour,'vol')
        

    end
    disp(strcat(name,' done'))

end

