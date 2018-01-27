%% ------------------------------------------------------------------
% RCDA matlab code, by K. K. Huang.
%
% Reference:
% Ke-Kun Huang, Dao-Qing Dai and Chuan-Xian Ren.  
% Regularized Coplanar Discriminant Analysis for Dimensionality Reduction.  
% Pattern Recognition, vol. 62, no.2, pp. 87-98, 2017. 

% Email: kkcocoon@163.com (K. K. Huang)
%
% Abstract: The dimensionality reduction methods based on linear embedding, 
% such as neighborhood preserving embedding (NPE), sparsity preserving projections (SPP) 
% and collaborative representation based projections (CRP), 
% try to preserve a certain kind of linear representation for each sample after projection.
% However, in the transformed low-dimensional space, 
% the linear relationship between the samples may be changed, 
% which can not make the linear representation-based classifiers, 
% such as sparse representation-based classifier (SRC), to achieve higher recognition accuracy.
% In this paper, we propose a new linear dimensionality reduction algorithm, 
% called Regularized Coplanar Discriminant Analysis (RCDA) to address this problem.
% It simultaneously seeks a linear projection matrix and 
% some linear representation coefficients that make the samples from the same class coplanar 
% and the samples from different classes not coplanar.
% The proposed regularization term balances the bias from the optimal linear representation 
% and that from the class mean to avoid overfitting the training data, 
% and overcomes the matrix singularity in solving the linear representation coefficients.
% An alternative optimization approach is proposed to solve the RCDA model.
% Experiments are done on several benchmark face databases and hyperspectral image databases,
% and results show that RCDA can obtain better performance than other dimensionality reduction methods.

%% Read data
clear all; clc;
sdb = 'db_HSI_Indian9';  sdb_ind = 'db_HSI_Indian9_inda60';
load(sdb); load(sdb_ind);

% Randomly select training samples and testing samples. last para: the 2nd group
[TrainX,TrainClass,TestX,TestClass,trind,ttind] =  fun_RandomSelect(TrainX,TrainClass,TrainInds,2);

% set parameters
dims = 60;  % reduced dimension for classification
classids       =    unique(TrainClass);
NumClass       =    length(classids);
tt_num         =    size(TestX,2);
tr_num         =    size(TrainX,2);

%% Without dimension reduction, too slow
% sMethod='RAW+SRC';
% [reco_ratio,tt_ID,tsrc] = fun_SRC(TrainX,TrainClass,TestX,TestClass);
% disp([ num2str(size(TrainX,1)) ' ' fun_dispRecoAcc(TestClass,tt_ID) ' % ' sMethod]);

%% Dimension reduction by PCA
W_pca  =  Eigenface_f(TrainX,tr_num);
TrainX   =  W_pca'* TrainX;
TestX    =  W_pca'* TestX;

%% Normalization
TrainX  = TrainX./ repmat(sqrt(sum(TrainX.*TrainX)),[size(TrainX,1) 1]);
TestX   =  TestX./ repmat(sqrt(sum(TestX.*TestX)),[size(TestX,1) 1]);

%% Classification by PCA+SRC
sMethod = 'PCA+SRC';
di=dims(end);
tTrainX = TrainX(1:di,:);
tTestX = TestX(1:di,:);
[reco_ratio,tt_ID] = fun_SRC(tTrainX,TrainClass,tTestX,TestClass);
disp([ num2str(di) ' ' fun_dispRecoAcc(TestClass,tt_ID) ' % ' sMethod]);

%% Rgularized Coplanar Discriminant Analysis
sMethod = 'RCDA+SRC';
options=[];
options.iters=1;      
options.ReducedDim=dims(end);
options.dpca=round([options.ReducedDim*2]);  
options.Mb = 0;  % option for between scatter
options.lamc = 0.06; 

if options.dpca>size(TrainX,1)
    options.dpca=size(TrainX,1);
end

if options.ReducedDim>options.dpca
    options.ReducedDim=options.dpca;
end

TrainXp = TrainX(1:options.dpca,:);
TestXp = TestX(1:options.dpca,:);
   
Wdr = fun_RCDA(TrainXp,TrainClass,options);
TrainXdr = Wdr'*TrainXp; 
TestXdr = Wdr'*TestXp; 

di = dims(end);
tTrainX = TrainXdr(1:di,:);
tTestX = TestXdr(1:di,:);
[reco_ratio,tt_ID] = fun_SRC(tTrainX,TrainClass,tTestX,TestClass);
disp([ num2str(di) ' ' fun_dispRecoAcc(TestClass,tt_ID) ' % ' sMethod]);

%% result
% 60 65.84   % PCA+SRC
% 60 72.50   % RCDA+SRC