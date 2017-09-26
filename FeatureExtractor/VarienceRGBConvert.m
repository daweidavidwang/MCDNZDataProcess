folderGT = 'I:\DatasetWithSecondFeature_aug3\GT\jpg';
folderMat = 'I:\DatasetWithSecondFeature_aug3\64SPP\Feature';
folderExr = 'I:\DatasetWithSecondFeature_aug3\64SPP\varexr';
filepathGt = [];
ext               =  {'*.jpg'};
for i = 1 : length(ext)
    filepathGt = cat(1,filepathGt, dir(fullfile(folderGT, ext{i})));
end

for i = 1 : length(filepathGt)
     image = imread(fullfile(folderGT,filepathGt(i).name));
     input_im = load( char(fullfile(folderMat,[filepathGt(i).name(1:end-4),'.mat'] )) );
     input_im = single(reshape(input_im.Var,[size(image,2) size(image,1) 18]));
     input_im = permute( input_im(:,:,3:end), [2,1,3] );
     luminance = 0.2126*input_im(:,:,1)+0.7952*input_im(:,:,2)+0.0722*input_im(:,:,3);
     exrwrite(luminance,fullfile(folderExr,[filepathGt(i).name(1:end-4),'.exr']));
end

     