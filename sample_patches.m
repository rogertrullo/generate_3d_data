pathpatients='~/Downloads/patient_test/';
name=datasave{1}{1};
ctvol=datasave{1}{2};
%organmask=datasave{1}{4}{1,2};%labels numbered 1,2...C 
organmask=load(strcat(pathpatients,name,'/gt.mat'));
organmask=organmask.vol;

[rows,cols,slices]=size(organmask);
all_organ_mask=organmask;


body=load(strcat(pathpatients,name,'/contour.mat'));
body=body.vol;

for i=2:4
  all_organ_mask=or(all_organ_mask,datasave{1}{4}{i,2}); 
    
end
%the organmask should be true in all positions where an organs is located



nsamples=10000;%number of samples for each class
patch_sz=[32,32,16];


maskborders=ones(size(all_organ_mask));

maskborders(rows-patch_sz(1)+1:rows,cols-patch_sz(2)+1:cols,slices-patch_sz(3)+1:slices)=0;% we put zero so we cant choose patches containing
%elements out of range

maskbody=and(body,maskborders);
mask_eso=(organmask==1).*maskborders;
mask_heart=(organmask==2).*maskborders;
mask_trach=(organmask==3).*maskborders;
mask_aorta=(organmask==4).*maskborders;





bgidx=find(and(maskbody,~all_organ_mask)>0);
organidx=find(mask_trach==1);

list_rnd=randperm(length(organidx),nsamples);

samplesbg_idx=organidx(list_rnd);

size(samplesbg_idx)

[r,c,z]=ind2sub(size(maskbody),samplesbg_idx(1))

imshow(ctvol(:,:,z),[])
hold on
rectangle('Position',[c r patch_sz(2) patch_sz(1)],'EdgeColor','r')





