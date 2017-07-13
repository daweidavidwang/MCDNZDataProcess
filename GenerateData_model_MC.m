clear;close all;dbstop if error;

addpath(genpath('./.'));

batchSize      = 128*3;        %%% batch size
max_numPatches = batchSize*2000; 
modelName      = 'model_MC_Res_Bnorm_Adam';

%%% training and testing
folder_train  = 'datasetcombine';  %%% training
folder_val   = 'datasetcombine';%%% testing

size_input    = 40;          %%% training
size_label    = 40;          %%% testing
stride_train  = 20;          %%% training
% stride_test   = 80;          %%% testing
stride_test   = 30;          %%% testing

val_train     = 0;           %%% training % default
val_test      = 1;           %%% testing  % default

%%% testing  patches
[inputs2,labels2,set2] = mat_patches_generation_log(size_input,size_label,stride_test,folder_val,val_test,max_numPatches,batchSize);

%%% training patches
[inputs, subNum, order,set]  = mat_patches_generation_log_inputs(size_input,size_label,stride_train,folder_train,val_train,max_numPatches,batchSize);
inputs   = cat(4,inputs,inputs2);      clear inputs2;
save(fullfile(modelName,'imdb'),'inputs','-v7.3');
clear inputs;
[labels]  = mat_patches_generation_log_labels(size_input,size_label,stride_train,folder_train,val_train,max_numPatches,batchSize,subNum,order);
labels   = cat(4,labels,labels2);      clear labels2;
save(fullfile(modelName,'imdb'),'labels','-append');
clear labels;

set      = cat(2,set,set2);            clear set2;


if ~exist(modelName,'file')
    mkdir(modelName);
end
save(fullfile(modelName,'imdb'),'set','-append');
clear('set');
%%clear('labels');
%inputs   = cat(4,inputs,inputs2);      clear inputs2;
%save(fullfile(modelName,'imdb'),'inputs','-append');




%%% save data
%save(fullfile(modelName,'imdb'), 'inputs','labels','set','-v7.3')
% load fullfile(modelName,'imdb.mat');
% implay ( [inputs,inputs-labels] );
