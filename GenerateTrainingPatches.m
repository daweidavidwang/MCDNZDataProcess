
%%% Generate the training data.

clear;close all;

addpath('utilities');

batchSize      = 128;        %%% batch size
dataName      = 'TrainingPatches';
trainFolder        = 'TrainMat';
% valFolder = 'ValMat';

patchsize     = 40;
stride        = 10;
step          = 0;

count   = 0;

ext               =  {'*.mat'};
GTfilepaths           =  [];
INPUTfilepaths = [];

for i = 1 : length(ext)
    GTfilepaths = cat(1,GTfilepaths, dir(fullfile(trainFolder,'gt', ext{i})));
    INPUTfilepaths = cat(1,GTfilepaths, dir(fullfile(trainFolder,'data', ext{i})));
end

%% count the number of extracted patches
% scales  = [1 0.9 0.8 0.7];
for i = 1 : length(GTfilepaths)
    
    image_label = load(fullfile(trainFolder,GTfilepaths(i).name)); % single
%     if size(image,3)==3
%         image = rgb2gray(image);
%     end
    %[~, name, exte] = fileparts(filepaths(i).name);
    if mod(i,100)==0
        disp([i,length(GTfilepaths)]);
    end
%     for s = 1:4
%         image_label = imresize(image_label,scales(s),'bicubic');
        [hei,wid,~] = size(image_label);
        for x = 1+step : stride : (hei-patchsize+1)
            for y = 1+step :stride : (wid-patchsize+1)
                count = count+1;
            end
        end
    end
% end

numPatches = ceil(count/batchSize)*batchSize;

disp([numPatches,batchSize,numPatches/batchSize]);

%pause;

inputs  = zeros(patchsize, patchsize, 1, numPatches,'single'); % this is fast
count   = 0;
tic;
for i = 1 : length(GTfilepaths)
    
    image_label = load(fullfile(trainFolder,GTfilepaths(i).name)); % single
    %[~, name, exte] = fileparts(filepaths(i).name);
%     if size(image_label,3)==3
%         image_label = rgb2gray(image_label);
%     end
    if mod(i,100)==0
        disp([i,length(GTfilepaths)]);
    end
    %     end
%     for s = 1:4
%         image_label = imresize(image_label,scales(s),'bicubic');
        for j = 1:1
            image_aug = data_augmentation(image_label, j);  % augment data
            im_label  = im2single(image_aug); % single
            [hei,wid,~] = size(im_label);
            
            for x = 1+step : stride : (hei-patchsize+1)
                for y = 1+step :stride : (wid-patchsize+1)
                    count       = count+1;
                    inputs(:, :, :, count)   = im_label(x : x+patchsize-1, y : y+patchsize-1,:);
                end
            end
        end
%     end
end
toc;
set    = uint8(ones(1,size(inputs,4)));

disp('-------Datasize-------')
disp([size(inputs,4),batchSize,size(inputs,4)/batchSize]);

if ~exist(dataName,'file')
    mkdir(dataName);
end

%%% save data
save(fullfile(dataName,['imdb_',num2str(patchsize),'_',num2str(batchSize)]), 'inputs','set','-v7.3')

