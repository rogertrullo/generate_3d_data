%%
clear all
clc


pathpatients='../patient_test/';
direc= dir(pathpatients);
patientlist={direc.name}';
patientlist=patientlist(3:end);%ubuntu in mac is 4
patch_sz=[32,32,16];
nsamples=700;
nclasses=5;
idpatch=1;
% X=zeros(length(patientlist)*nsamples*nclasses,1,patch_sz(1),patch_sz(2),patch_sz(3));
% y=zeros(length(patientlist)*nsamples*nclasses,patch_sz(1),patch_sz(2),patch_sz(3));

X=zeros(patch_sz(2),patch_sz(1),patch_sz(3),1,nsamples*nclasses);
y=zeros(patch_sz(2),patch_sz(1),patch_sz(3),nsamples*nclasses);



%for idpatient=1:length(patientlist)%for every patient
for idpatient=1:5%just to test
    name=patientlist{idpatient};
    
    body=load(strcat(pathpatients,name,'/contour.mat'));
    body=body.vol;
    
    [rows,cols,slices]=size(body);
    
    
    %read the ctvol and segvol; we use the niireader from Dirks 
    
    ctvol=nii_read_volume(strcat(pathpatients,name,'/',name,'.nii.gz'));
    
    segvol=load(strcat(pathpatients,name,'/','gt.mat'));
    segvol=segvol.vol;
    
    all_organs_mask=segvol>0;
    maskborders=ones(size(ctvol));
    
    maskborders(rows-patch_sz(1)+1:rows,:,:)=0;
    maskborders(:,cols-patch_sz(2)+1:cols,:)=0; 
    maskborders(:,:,slices-patch_sz(3)+1:slices)=0;   
    
    maskbody=and(body,maskborders); 
    mask_eso=and((segvol==1),maskborders);
    mask_heart=and((segvol==2),maskborders);
    mask_trach=and((segvol==3),maskborders);
    mask_aorta=and((segvol==4),maskborders);
    
    bgidx=find(and(maskbody,~all_organs_mask)>0);
    esoidx=find(mask_eso==1);
    heartidx=find(mask_heart==1);
    trachidx=find(mask_trach==1);
    aortaidx=find(mask_aorta==1);
    
    
    
    
    
    list_rndbg=randperm(length(bgidx),nsamples);
    list_rndbg=bgidx(list_rndbg);
    
    list_rndeso=randperm(length(esoidx),nsamples);
    list_rndeso=esoidx(list_rndeso);
    
    list_rndheart=randperm(length(heartidx),nsamples);
    list_rndheart=heartidx(list_rndheart);

    list_rndtrach=randperm(length(trachidx),nsamples);
    list_rndtrach=trachidx(list_rndtrach);
    
    list_rndaorta=randperm(length(aortaidx),nsamples);
    list_rndaorta=aortaidx(list_rndaorta);
    
    clear maskbody maskborders all_organs_mask mask_eso mask_heart mask_trach mask_aorta body
    
    
    for i=1:length(list_rndbg)
        [r,c,z]=ind2sub(size(ctvol),list_rndbg(i));       
        %X(idpatch,1,:,:,:)=ctvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1);
        %y(idpatch,:,:,:)=segvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1);
        
        X(:,:,:,1,idpatch)=permute(ctvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1),[2 1 3]);
        y(:,:,:,idpatch)=permute(segvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1),[2 1 3]);
        
        idpatch=idpatch+1;
    end
    
    for i=1:length(list_rndeso)
        [r,c,z]=ind2sub(size(ctvol),list_rndeso(i));       
%         X(idpatch,1,:,:,:)=ctvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1);
%         y(idpatch,:,:,:)=segvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1);
        X(:,:,:,1,idpatch)=permute(ctvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1),[2 1 3]);
        y(:,:,:,idpatch)=permute(segvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1),[2 1 3]);
        idpatch=idpatch+1;
    end
    
    for i=1:length(list_rndheart)
        [r,c,z]=ind2sub(size(ctvol),list_rndheart(i));       
%         X(idpatch,1,:,:,:)=ctvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1);
%         y(idpatch,:,:,:)=segvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1);
        X(:,:,:,1,idpatch)=permute(ctvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1),[2 1 3]);
        y(:,:,:,idpatch)=permute(segvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1),[2 1 3]);
        idpatch=idpatch+1;
    end
    
    for i=1:length(list_rndtrach)
        [r,c,z]=ind2sub(size(ctvol),list_rndtrach(i));       
%         X(idpatch,1,:,:,:)=ctvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1);
%         y(idpatch,:,:,:)=segvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1);
        X(:,:,:,1,idpatch)=permute(ctvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1),[2 1 3]);
        y(:,:,:,idpatch)=permute(segvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1),[2 1 3]);
        idpatch=idpatch+1;
    end
    
    for i=1:length(list_rndaorta)
        [r,c,z]=ind2sub(size(ctvol),list_rndaorta(i));       
%         X(idpatch,1,:,:,:)=ctvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1);
%         y(idpatch,:,:,:)=segvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1);
        X(:,:,:,1,idpatch)=permute(ctvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1),[2 1 3]);
        y(:,:,:,idpatch)=permute(segvol(r:r+patch_sz(1)-1,c:c+patch_sz(2)-1,z:z+patch_sz(3)-1),[2 1 3]);
        idpatch=idpatch+1;
    end
    
    idpatch=1;
    disp([name,' done'])
    
    rndidx=randperm(size(X,5));
    X=X(:,:,:,:,rndidx);
    y=y(:,:,:,rndidx);
    disp('all patches in memory')
    
    h5create(sprintf('/media/roger/48BCFC2BBCFC1562/train%d.h5',idpatient),'/data',size(X),'Datatype','double');
    h5create(sprintf('/media/roger/48BCFC2BBCFC1562/train%d.h5',idpatient),'/label',size(y),'Datatype','double');

    h5write(sprintf('/media/roger/48BCFC2BBCFC1562/train%d.h5',idpatient),'/data',X);
    h5write(sprintf('/media/roger/48BCFC2BBCFC1562/train%d.h5',idpatient),'/label',y);
    
end


%%
% patients_save=5;
% 
% for i=1:patients_save
%     h5create(sprintf('/media/roger/48BCFC2BBCFC1562/train%d.h5',i),'/data',size(X(:,:,:,:,(i-1)*nsamples*nclasses+1:i*nsamples*nclasses)),'Datatype','double');
%     h5create(sprintf('/media/roger/48BCFC2BBCFC1562/train%d.h5',i),'/label',size(y(:,:,:,(i-1)*nsamples*nclasses+1:i*nsamples*nclasses)),'Datatype','double');
% 
%     h5write(sprintf('/media/roger/48BCFC2BBCFC1562/train%d.h5',i),'/data',X(:,:,:,:,(i-1)*nsamples*nclasses+1:i*nsamples*nclasses));
%     h5write(sprintf('/media/roger/48BCFC2BBCFC1562/train%d.h5',i),'/label',y(:,:,:,(i-1)*nsamples*nclasses+1:i*nsamples*nclasses));
% end


disp('everythng done here')