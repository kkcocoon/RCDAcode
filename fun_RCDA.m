function  [eigvector, eigvalue,dJ] = fun_RCDA(TrainX,TrainClass,options)

classids       =    unique(TrainClass);
NumClass       =    length(classids);
tr_num         =    size(TrainX,2);

if (~exist('options','var'))
    options = [];
end

if ~isfield(options,'Mb')
    options.Mb = 1;
end    

if ~isfield(options,'iters')
    options.iters = 1;
end

if ~isfield(options,'lamc')
    options.lamc = 0.1;
end

% mean distance of sample pairs
if ~isfield(options,'lamm')
    A = EuDist2(TrainX',[],0);
    options.lamm = mean(A(:));
end

options.lamda = options.lamc * options.lamm;

ReducedDim = options.ReducedDim;
iters = options.iters;

if ReducedDim>size(TrainX,2)
    ReducedDim = size(TrainX,2);
end

J=0;
Cw0=[]; Cbs0=[];
for ti=0:iters
    
    if ti==0  % Initialization
        tTrainX = TrainX;
    end
    
    t = cputime;
    
    [Mw, Mb] = fun_RCDA_MwMb(tTrainX,TrainClass, options);
     
    Rw = TrainX*Mw*TrainX' / tr_num;
    if options.Mb==0
        Rb = TrainX*TrainX'/ (tr_num);
    else
        Rb = TrainX*Mb*TrainX'/ (tr_num*(NumClass-1));
    end

    J1 = trace(Rb)/trace(Rw);

    R = inv(Rw)*Rb;
    [V,D] = eig(R);
    D=diag(D);
    [Ds,Di] = sort(-D);
    W = V(:,Di(1:ReducedDim));

    tTrainX = W'*TrainX;

    dJ = round((J1-J)*10)/10;
    J=J1;
    
end

eigvector = V(:,Di(1:ReducedDim));
eigvalue = D(Di(1:ReducedDim));