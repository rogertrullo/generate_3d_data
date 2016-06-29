function cur_gt=merge_labels(datasave,idpatient)
%%Check the right order

organs={'BMD-Esophagus','BMD-Heart','BMD-Trachea','BMD-Aorta'};
micell=datasave{idpatient}{4};
organ_cell={};
%the organs must be in this order so the labels are consistent
for i=1:length(organs)
    [~,idx]=ismember(organs{i},micell(:,1));
    organ_cell{i}=micell{idx,2};
    
    
end


%%
cur_gt=uint8(organ_cell{1});%just copy the  first organ and it will have label 1
for i=1:length(organ_cell)-1
    
    %idx=find(and(cur_gt,organ_cell{i+1})>0);%the and operation should be zero since there shouldnt be overlapping
    tmp_next=organ_cell{i+1};
    tmp_next(and(cur_gt,organ_cell{i+1})>0)=0;% set to zeros the values that will overlap,so the previous organ will remain..
                                              %it is hacky but not sure how to handle it :/
    cur_gt=cur_gt + uint8((i+1)*tmp_next);%assign labelid
    
    

    
    
end

unique(cur_gt)

end