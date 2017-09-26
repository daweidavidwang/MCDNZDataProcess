clear;close all;dbstop if error;

addpath(genpath('./.'));

batchSize      = 128*3;        %%% batch size
max_numPatches = batchSize*2000; 
modelName      = 'model_MC_Res_Bnorm_Adam';

%%% training and testing
folder_train  = 'J:\TrainSetSS';  %%% training
folder_val   = 'J:\ValSetSS ';%%% testing
folder = 'I:\DatasetWithSecondFeature_aug3';

size_input    = 64;          %%% training
size_label    = 64;          %%% testing
stride_train  = 32;          %%% training
stride_test   = 40;          %%% testing

val_train     = 0;           %%% training % default
val_test      = 1;           %%% testing  % default

%%% testing  patches
[inputs,labels,set] = PatchHDRtanhhighpass(size_input,size_label,stride_test,folder,folder_train,val_train,max_numPatches,batchSize);
[inputs2,labels2,set2] = PatchHDRtanhhighpass(size_input,size_label,stride_test,folder,folder_val,val_test,max_numPatches,batchSize);

%%% training patches

inputs   = cat(4,inputs,inputs2); 

labels   = cat(4,labels,labels2);  

set      = cat(2,set,set2);  
if ~exist(modelName,'file')
    mkdir(modelName);
end
save(fullfile(modelName,'Aug2ss_HDR_tanh_highpass'),'inputs','labels','set','-v7.3');
clear('set');
%%clear('labels');
%inputs   = cat(4,inputs,inputs2);      clear inputs2;
%save(fullfile(modelName,'imdb'),'inputs','-append');




%%% save data
%save(fullfile(modelName,'imdb'), 'inputs','labels','set','-v7.3')
% load fullfile(modelName,'imdb.mat');
% implay ( [inputs,inputs-labels] );

