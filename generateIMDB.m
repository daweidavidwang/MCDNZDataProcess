clear;close all;
addpath(genpath('./.'));
batchSize      = 128;        %%% batch size
max_numPatches = batchSize*2000; 
modelName      = 'model_MC_Res_Bnorm_Adam';
%%% training and testing
folder_train  = 'TrainSet';  %%% training
folder_val   = 'ValSet';%%% testing

size_input    = 64;          %%% training
size_label    = 64;          %%% testing
stride_train  = 12;          %%% training
% stride_test   = 80;          %%% testing
stride_test   = 12;          %%% testing

val_train     = 0;           %%% training % default
val_test      = 1;           %%% testing  % default

%%% training patches
[inputs, labels, set]  = exr_patches_generation(size_input,size_label,stride_train,folder_train,val_train,max_numPatches,batchSize);
%%% testing  patches
[inputs2,labels2,set2] = exr_patches_generation(size_input,size_label,stride_test,folder_val,val_test,max_numPatches,batchSize);

inputs   = cat(4,inputs,inputs2);      clear inputs2;
labels   = cat(4,labels,labels2);      clear labels2;
set      = cat(2,set,set2);            clear set2;

if ~exist(modelName,'file')
    mkdir(modelName);
end

%%% save data
save(fullfile(modelName,'imdb'), 'inputs','labels','set','-v7.3')
% load fullfile(modelName,'imdb.mat');
% implay ( [inputs,inputs-labels] );
