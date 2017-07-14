matpath = 'E:\datasetcombine\16SPP\Feature';
prepath = 'E:\datasetcombine\16SPP\pre';
exrpath = 'E:\datasetcombine\16SPP';
ext = {'*.mat'};
filelist = [];

for i = 1 : length(ext)
    filelist = cat(1,filelist, dir(fullfile(matpath, ext{i})));
end

for i =  1 : length(filelist)
    input_im = load( char(fullfile(matpath,[filelist(i).name(1:end-4),'.mat'] )) );
    input_exr = exrread(fullfile(exrpath,[filelist(i).name(1:end-4),'_MC_0016.exr'] ));
    input_im = single(reshape(input_im.doublefeature,[size(input_exr,2) size(input_exr,1) 18]));
    input_im = permute( input_im(:,:,3:end), [2,1,3] );
     for k = 4:16
        input_im(:,:,k) = ( input_im(:,:,k) - min(min(input_im(:,:,k))) )/( max(max(input_im(:,:,k))) - min(min(input_im(:,:,k))) );
     end
     imwrite(input_im(:,:,4:6),fullfile(prepath,[filelist(i).name(1:end-4),'_pos.jpg']));
     imwrite(input_im(:,:,7:9),fullfile(prepath,[filelist(i).name(1:end-4),'_norm.jpg']));
     imwrite(input_im(:,:,10:12),fullfile(prepath,[filelist(i).name(1:end-4),'_tex1.jpg']));
     imwrite(input_im(:,:,13:15),fullfile(prepath,[filelist(i).name(1:end-4),'_tex2.jpg']));
     imwrite(input_im(:,:,16),fullfile(prepath,[filelist(i).name(1:end-4),'_vis.jpg']));
end
