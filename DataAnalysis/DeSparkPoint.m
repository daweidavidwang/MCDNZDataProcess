clear all;
folderSource = 'I:\MCdenoisingResult\HDR_BN15_L1_Aug2ss_epoch98_TestSet&ValSetSS\64SPP';
folderDestination = 'I:\MCdenoisingResult\RemoveSparkHDR_BN15_L1_Aug2ss_epoch98_TestSet&ValSetSS\64SPP';
ext         =  {'*.exr'};
filePaths   =  [];
filePaths = cat(1,filePaths, dir(fullfile(folderSource,ext{1})));
for i = 1:length(filePaths)
    image = exrread(fullfile(folderSource,[filePaths(i).name ] )) ;
    image = SpikeRemoval(image);
    exrwrite(image,fullfile(folderDestination,[filePaths(i).name ] ));
end