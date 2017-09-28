clear;close all;dbstop if error;

addpath(genpath('./.'));

batchSize      = 128*3;        %%% batch size
max_numPatches = batchSize*2000; 
modelName      = 'model_MC_Res_Bnorm_Adam';
FeatureMode = 2; 
%FeatureMode 1: Traditional 17channel;
%            2: SobelCVarN 13 channel;
%            3: 
alpha = 0.5636;
%alpha : tanh(alpha*x)
%%% training and testing
folder_train  = 'I:\DatasetWithSecondFeature_aug3\TrainSet0924AvoidLBFScene';  %%% training
folder_val   = 'I:\DatasetWithSecondFeature_aug3\Val0924AvoidLBFScene';%%% testing
folder = 'I:\DatasetWithSecondFeature_aug3';

size_input    = 64;          %%% training
size_label    = 64;          %%% testing
stride_train  = 32;          %%% training
stride_test   = 64;          %%% testing

val_train     = 0;           %%% training % default
val_test      = 1;           %%% testing  % default

%%% testing  patches
[inputs,labels,set] = PatchGenerationWithSecondFeatureHDRtanh(alpha,FeatureMode,size_input,size_label,stride_train,folder,folder_train,val_train,max_numPatches,batchSize);
[inputs2,labels2,set2] = PatchGenerationWithSecondFeatureHDRtanh(alpha,FeatureMode,size_input,size_label,stride_test,folder,folder_val,val_test,max_numPatches,batchSize);

%%% training patches

inputs   = cat(4,inputs,inputs2); 
clear inputs2;
save(fullfile('0924AvoidLBFSobelCVaarN'),'inputs','-v7.3');
clear inputs;
labels   = cat(4,labels,labels2); 
save(fullfile('0924AvoidLBFSobelCVaarN'),'labels','-append');
clear labels;
clear labels2
set      = cat(2,set,set2); 
save(fullfile('0924AvoidLBFSobelCVaarN'),'set','-append');
if ~exist(modelName,'file')
    mkdir(modelName);
end
clear('set');
%%clear('labels');
%inputs   = cat(4,inputs,inputs2);      clear inputs2;
%save(fullfile(modelName,'imdb'),'inputs','-append');




%%% save data
%save(fullfile(modelName,'imdb'), 'inputs','labels','set','-v7.3')
% load fullfile(modelName,'imdb.mat');
% implay ( [inputs,inputs-labels] );

