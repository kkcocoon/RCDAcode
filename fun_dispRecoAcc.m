function reco_ratio = fun_dispRecoAcc(TestClass,tt_ID,inds,remark)
 
if ~exist('inds')
    inds = {};
end

if ~exist('remark')
    remark = '';
end

if length(inds)==0
    inds{1} = 1:length(TestClass);
    
%     classidstt   =    unique(TestClass);
%     for i=1:length(classidstt)
%         ind = find(TestClass==classidstt(i));
%         inds = [inds,{ind}];
%     end
end



reco_ratio= [];
for i=1:length(inds)
    ind = inds{i};
    tr = (sum(tt_ID(ind)==TestClass(ind)))/length(ind);
    tr = round(10000*tr)/100;
    reco_ratio = [reco_ratio,tr];
end
reco_ratio = fun_Format(reco_ratio);
% disp([reco_ratio, '% ', remark]);