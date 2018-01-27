function [TrainX,TrainClass,TestX,TestClass,trind,ttind] =  fun_RandomSelect(allX,allClass,TrainInds,ri);

% Select group ri according to TrainInds as training samples, the remain as testing samples.
% The indexes of the training samples for each class for each experiment is indicated by a row of "TrainInds".

if ~exist('ri')
    ri=1;
end

classids1       =    unique(allClass);
NumClass1       =    length(classids1);

TrainX = [];    TrainClass = [];
TestX = [];    TestClass = [];
trind=[];ttind=[];
rii=(ri-1)*NumClass1 + 1;
for ci=1:NumClass1
    cind = find(allClass==classids1(ci));
    tind = TrainInds(rii,:);  rii=rii+1;  % different indexes for different classes
    tind(find(tind==0)) = [];
    
    trind = [trind, cind(tind)];
    cind(tind) = [];
    
    if length(tind)>0
        ttind = [ttind, cind];
    end
end

TrainX = allX(:,trind);
TrainClass = allClass(trind);

TestX = allX(:,ttind);
TestClass = allClass(ttind);
