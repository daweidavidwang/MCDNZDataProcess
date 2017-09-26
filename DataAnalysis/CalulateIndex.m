clear all;
folderTest = 'I:\MCdenoisingResult\HDR_BN15_L1_Aug2ss_epoch98_TestSet&ValSetSS\4SPP';
folderTestGT = 'I:\DatasetWithSecondFeature_aug2\TestSet&ValSetSS';
SSIMall = [];
PNSRall = [];
ext         =  {'*.exr'};
filePaths   =  [];
epsilon = 0.01;
filePaths = cat(1,filePaths, dir(fullfile(folderTestGT,ext{1})));
for i = 1:length(filePaths)
    label = exrread(fullfile(folderTestGT,[filePaths(i).name ] )) ;
    input_jpg =  exrread( fullfile(folderTest,[filePaths(i).name(1:end-4),'.exr']));
%     result(i).psnr = psnr(label,input_jpg);
%     result(i).ssim = ssim(label,input_jpg);
%     ReMSE = ((input_jpg-label).^2)./(label.^2+epsilon);
%     result(i).ReMSE = mean(ReMSE(:));
    result(i).name = filePaths(i).name;
    MSE = (input_jpg-label).^2;
    result(i).MSE = mean(MSE(:));
end