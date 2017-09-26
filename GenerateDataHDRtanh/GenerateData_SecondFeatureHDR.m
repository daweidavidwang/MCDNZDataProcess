clear;close all;dbstop if error;

addpath(genpath('./.'));

batchSize      = 128*3;        %%% batch size
max_numPatches = batchSize*2000; 
modelName      = 'model_MC_Res_Bnorm_Adam';

%%% training and testing
folder_train  = 'G:\DatasetWithSecondFeature_aug3\onecheck';  %%% training
folder_val   = 'G:\DatasetWithSecondFeature_aug3\onecheck';%%% testing
folder = 'G:\DatasetWithSecondFeature_aug3';

size_input    = 64;          %%% training
size_label    = 64;          %%% testing
stride_train  = 32;          %%% training
stride_test   = 40;          %%% testing

val_train     = 0;           %%% training % default
val_test      = 1;           %%% testing  % default

%%% testing  patches
[inputs,labels,set] = PatchGenerationWithSecondFeatureHDRtanh(size_input,size_label,stride_test,folder,folder_train,val_train,max_numPatches,batchSize);
[inputs2,labels2,set2] = PatchGenerationWithSecondFeatureHDRtanh(size_input,size_label,stride_test,folder,folder_val,val_test,max_numPatches,batchSize);

%%% training patches

inputs   = cat(4,inputs,inputs2); 
clear inputs2;
save(fullfile('onecheck'),'inputs','-v7.3');
clear inputs;
labels   = cat(4,labels,labels2); 
save(fullfile('onecheck'),'labels','-append');
clear labels;
clear labels2
set      = cat(2,set,set2); 
save(fullfile('onecheck'),'set','-append');
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

