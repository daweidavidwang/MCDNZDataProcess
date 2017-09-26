matpath = 'G:\DatasetWithSecondFeature_aug2\32SPP\NewFeature';
prepath = 'G:\DatasetWithSecondFeature_aug2\32SPP\pre';
ext = {'*.mat'};
filelist = [];

for i = 1 : length(ext)
    filelist = cat(1,filelist, dir(fullfile(matpath, ext{i})));
end

for i =  1 : length(filelist)
    input_im = load( char(fullfile(matpath,[filelist(i).name(1:end-4),'.mat'] )) );
    input_im = input_im.SecondFeature;
     imwrite(input_im(:,:,1),fullfile(prepath,[filelist(i).name(1:end-4),'_gxpos.jpg']));
     imwrite(input_im(:,:,2),fullfile(prepath,[filelist(i).name(1:end-4),'_gypos.jpg']));
     imwrite(input_im(:,:,3),fullfile(prepath,[filelist(i).name(1:end-4),'_gxnorm.jpg']));
     imwrite(input_im(:,:,4),fullfile(prepath,[filelist(i).name(1:end-4),'_gynorm.jpg']));
     imwrite(input_im(:,:,5),fullfile(prepath,[filelist(i).name(1:end-4),'_gxtex1.jpg']));
     imwrite(input_im(:,:,6),fullfile(prepath,[filelist(i).name(1:end-4),'_gytex1.jpg']));
     imwrite(input_im(:,:,7),fullfile(prepath,[filelist(i).name(1:end-4),'_gxtex2.jpg']));
     imwrite(input_im(:,:,8),fullfile(prepath,[filelist(i).name(1:end-4),'_gytex2.jpg']));
     imwrite(input_im(:,:,9),fullfile(prepath,[filelist(i).name(1:end-4),'_vis.jpg']));
     imwrite(input_im(:,:,10),fullfile(prepath,[filelist(i).name(1:end-4),'_varcolor.jpg']));
     imwrite(input_im(:,:,11),fullfile(prepath,[filelist(i).name(1:end-4),'_varpos.jpg']));
     imwrite(input_im(:,:,12),fullfile(prepath,[filelist(i).name(1:end-4),'_varnorm.jpg']));
     imwrite(input_im(:,:,13),fullfile(prepath,[filelist(i).name(1:end-4),'_vartex1.jpg']));
     imwrite(input_im(:,:,14),fullfile(prepath,[filelist(i).name(1:end-4),'_vartex2.jpg']));
end
