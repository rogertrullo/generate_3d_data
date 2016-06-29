clear all;
addpath(genpath('fonctions'))
%savepath


pathScan = '/Users/trullro/Downloads/patient_test'; % to be changed!

patientList = dir(pathScan); 
patientList = patientList(4:end);%4 if it is mac, 3 ubuntu

datasave= {};
parfor i = 1:size(patientList,1) % Patients iteration
    tmp={};

    patientName = patientList(i).name;
    %dataSave1{i,1} = patientName;
    tmp{1}=patientName;
    pathPatient = [pathScan '/' patientName];

    % CT----------------------------------------------------
    pathCT = [pathPatient, '/CT'];

    examFiles = dir(pathCT); 
    fid = fopen(sprintf('listExamFiles%d.txt',i),'w');
    for ii = 3:size(examFiles,1)    
        fprintf(fid,'%s\n',[pathCT '/' examFiles(ii).name]);
    end

    [ctcell, ct_xmesh, ct_ymesh, ct_zmesh] = dicomrt_loadct(sprintf('listExamFiles%d.txt',i));
    examCT = ctcell{2,1};
    infoCT = ctcell{1,1};
    %dataSave1{i,2} = examCT;
    %dataSave1{i,3} = infoCT;
    tmp{2}= examCT;
    tmp{3}= infoCT;

    % MASK--------------------------------------------------

    pathRT = [pathPatient, '/RTstruct'];    
    RTName = dir(pathRT); RTName = RTName(3).name;
    
    cellVOI = dicomrt_loadvoi([pathRT '/' RTName]);
    n=1;   
    idx=[];
    saveflag=false;
    listMasks = {};

    for j = 1:size(cellVOI{2,1},1)
        %if (strcmp(cellVOI{2,1}{j,1},'BMD-Esophagus') || strcmp(cellVOI{2,1}{j,1},'BMD-Heart')|| strcmp(cellVOI{2,1}{j,1},'BMD-Trachea')|| strcmp(cellVOI{2,1}{j,1},'BMD-Aorta'))
        if (strcmpi(cellVOI{2,1}{j,1},'CONTOUR EXTERNE')|| strcmpi(cellVOI{2,1}{j,1},'body'))
        listMasks{n,1} = cellVOI{2,1}{j,1};
        n=n+1;
        idx=[idx,j];%index of voi
        saveflag=true;
        end
        
    end
    
    masks1 = {}; %segmentations made by BD are in binary format in masks1
    for uu = 1:size(listMasks,1) % Parcours des segmentations       
        [~, VOI] = dicomrt_build3dVOI_old(cellVOI, ctcell, ct_xmesh, ct_ymesh, ct_zmesh, idx(uu));
        VOI = VOI>0;
        masks1{uu,1} = listMasks{uu};
        masks1{uu,2} = VOI;
        for k=1:size(VOI,3)%save the slices
            imwrite(VOI(:,:,k),strcat(pathPatient,'/',listMasks{uu},sprintf('%d.png',k)))
        end
        
        
    end
    if saveflag
    %dataSave1{i,4} = masks1;
    tmp{4}=masks1;
    else
        disp(strcat(patientName,' segmentation not found'))
    end
    datasave{i}=tmp;

end
delete(gcp('nocreate'))
save('datasave.mat','datasave')