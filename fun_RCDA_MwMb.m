function  [Mw, Mb] = fun_RCDA_MwMb(TrainX,TrainClass,options)

% ------------------------------------------------------------------
classids       =    unique(TrainClass);
NumClass       =    length(classids);
tr_num         =    size(TrainX,2);

if (~exist('options','var'))
    options = [];
end

if ~isfield(options,'Mb')
    options.Mb = 1;
end  

lamda = 0.1;
if isfield(options,'lamda')
    lamda = options.lamda;
end

%% within-class scatter
Cw = zeros(tr_num,tr_num);
for c   =  1:NumClass
    ind = find(TrainClass==classids(c));
    
    Xc = TrainX(:,ind);  
    
    for i=1:size(Xc,2)
        indw = [1:i-1,i+1:size(Xc,2)];
        X=Xc(:,indw);
        y=Xc(:,i);

        I = eye(size(X,2));
        I1 = ones(size(X,2),1)/size(X,2);
        
        b = inv(X'*X+lamda*I)*(X'*y+lamda*I1);

        Cw(ind(i),ind(indw)) = b';
    end
end
I = eye(tr_num,tr_num);
Mw = (I-Cw)'*(I-Cw);

Mb=[];
if options.Mb==0
    return;
end

%% between-class scatter
Mb = zeros(tr_num,tr_num);
for j=1:NumClass 
    % construct project matrix once
    ind = find(TrainClass==classids(j));
    X = TrainX(:,ind);
    I = eye(size(X,2)); 
%     I1 = 0;
    I1 = ones(size(X,2),1)/size(X,2);
    P1 = inv(X'*X+lamda*I);
%     P = inv(X'*X+lamda*I)*X';

    Cb = zeros(tr_num,tr_num);
    for i=1:tr_num
        y = TrainX(:,i);
        
        I = eye(size(X1,2));
        b = inv(X'*X+lamda*I)*X'*y;
        Cb(i,ind) = b';        
           
    end
    I = eye(tr_num,tr_num);
    Mb = Mb + (I-Cb)'*(I-Cb);
end
