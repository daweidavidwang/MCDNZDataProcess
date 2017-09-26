%%% test the model performance
clear;clc;close;
matConvNetPath = 'E:\matconvnet-1.0-beta22\matconvnet-1.0-beta22';
run( fullfile(matConvNetPath,'matlab','vl_setupnn.m') );
% clear; clc;
format compact;

addpath(fullfile('data','utilities'));
folderTest  = fullfile('I:\DatasetWithSecondFeature_aug3\4SPP\exr\'); %%% test dataset
folderTestGt  = fullfile('I:\DatasetWithSecondFeature_aug2\TrainSetSS\2'); %%% test dataset
folderTestPre = fullfile('I:\MCdenoisingResult\HDR_BN20_5x5IO_NF_Res0801\Transet');
showResult  = 0;
useGPU      = 0;
pauseTime   = 0; 
saveresult = 1;
SSIMall= [];
PSNRall = [];
ext         =  {'*.exr'};
filePaths   =  [];
for i = 1 : length(ext)
    filePaths = cat(1,filePaths, dir(fullfile(folderTestGt,ext{i})));
end

for epoch = 28:10:28
epoch       = 26;
load('\\Desktop-7lp6233\d\HDR_BN20_Aug2ss_NewRes_NewFeature\data\model_MC_Res_Bnorm_Adam\model_MC_Res_Bnorm_Adam-epoch-25.mat');
net = vl_simplenn_tidy(net);
net.layers = net.layers(1:end-1);
if useGPU
    net = vl_simplenn_move(net, 'gpu') ;
end
time = zeros(length(filePaths),1);
for i = 1:length(filePaths)
    tic;
    label = exrread(fullfile(folderTestGt,[filePaths(i).name ] )) ;
    input_jpg =  exrread( fullfile(folderTest,[filePaths(i).name(1:end-4),'_MC_0004.exr'] ) );
    input_feature = load( fullfile(folderTest,['../NewFeature/',filePaths(i).name(1:end-4),'.mat'] ) );
    input = cat(3,input_jpg,input_feature.SecondFeature);
    [~,nameCur,extCur] = fileparts(filePaths(i).name);
    if useGPU
        input = gpuArray(input);
    end
    res    = vl_simplenn(net,input,[],[],'conserveMemory',true,'mode','test');
%     output = input(:,:,1:3) - res(end).x;
    output =  res(end).x;
    if useGPU
        output = gather(output);
        input  = gather(input);
    end
    output(output>=1)=0.99999;
    output(output<=-1)=-0.9999;
    output = atanh(output)/0.5636;
    output = input_jpg - output;
    %imwrite(im2uint8(output),fullfile(folderTestPre,[filePaths(i).name(1:end-4),'.png']),'png');
    time(i,1) = toc;
    if saveresult
        exrwrite(output,fullfile(folderTestPre,[filePaths(i).name(1:end-4),'.exr']));
    end
    

    if showResult
        PSNRCur = psnr(im2uint8(output),im2uint8(label));
        SSIMCur = ssim(im2uint8(output),im2uint8(label));
        result(i).PSNRs = PSNRCur;
        result(i).SSIMs = SSIMCur;
        result(i).name = filePaths(i).name;
        imshow(cat(2,(im2uint8(label)),(im2uint8(input_jpg)),(im2uint8(output))));
        title([filePaths(i).name,'    ',num2str(PSNRCur,'%2.2f'),'dB','    ',num2str(SSIMCur,'%2.4f')])
        drawnow;
        disp SSIM:;disp (SSIMCur);
        disp PSNR:;disp(PSNRCur);
        pause(pauseTime)
    end
end
%     SSIMall(epoch,:) = [result.SSIMs];
%     PSNRall(epoch,:) = [result.PSNRs];
% disp([mean([result.PSNRs]),mean([result.SSIMs])]);
end

legend(filePaths.name)
