function [reco_ratio,tt_ID,tsrc] = fun_SRC(tTrainX,TrainClass,tTestX,TestClass,opt)
 
if (~exist('opt','var'))
    opt = [];
end

if ~isfield(opt,'lambda')
    opt.lambda = 0.001;
end

classids   =    unique(TrainClass);
NumClass   =    length(classids);
tr_num     =    size(tTrainX,2);
tt_num     =    size(tTestX,2);
tt_ID      =    zeros(1,tt_num);
gap        =    zeros(1,NumClass);

indsl=[0];
classidstt   =    unique(TestClass);
for i=1:length(classidstt)
    ind = find(TestClass==classidstt(i));
    indsl = [indsl,indsl(end)+length(ind)];
end

tTrainX  =  tTrainX./ repmat(sqrt(sum(tTrainX.*tTrainX)),[size(tTrainX,1) 1]); 
tTestX   =  tTestX./ repmat(sqrt(sum(tTestX.*tTestX)),[size(tTestX,1) 1]); 

bt=clock;
ds=0;
for i  =  1:tt_num  
    s = SolveDALM(tTrainX, tTestX(:,i),'lambda',opt.lambda); 
   
    for j   =  1:NumClass
        ind = find(TrainClass==classids(j));
        temp_s =  zeros(size(s));
        temp_s(ind)  =  s(ind);
        zz     =  tTestX(:,i)-tTrainX*temp_s;
        gap(j) =  zz(:)'*zz(:); 
    end
        
    [mg,mi] = min(gap);
    tt_ID(i)  =  classids(mi);
end

reco_ratio=(sum(tt_ID==TestClass(1:tt_num)))/tt_num; 
reco_ratio = round(10000*reco_ratio)/100;
tsrc = etime(clock,bt);
tsrc = num2str(round(tsrc));