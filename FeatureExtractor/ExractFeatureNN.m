folderGT = 'I:\DatasetWithSecondFeature_aug3\GT\jpg';
folderMat = 'I:\DatasetWithSecondFeature_aug3\4SPP\Feature';
folderJpg = 'I:\DatasetWithSecondFeature_aug3\4SPP\varexr\jpg';
folderNewFeature = 'I:\DatasetWithSecondFeature_aug3\4SPP\FeatureNN';
filepathGt = [];

ext               =  {'*.jpg'};
for i = 1 : length(ext)
    filepathGt = cat(1,filepathGt, dir(fullfile(folderGT, ext{i})));
end

for i = 1 : length(filepathGt)
     image = imread(fullfile(folderGT,filepathGt(i).name));
     input_im = load( char(fullfile(folderMat,[filepathGt(i).name(1:end-4),'.mat'] )) );
     input_var = single(reshape(input_im.Var,[size(image,2) size(image,1) 18]));
     SecondFeature  = zeros(size(image,1), size(image,2), 14, 'single');
     input_var = permute( input_var(:,:,3:end), [2,1,3] );
     input_fea = single(reshape(input_im.FirstFeature,[size(image,2) size(image,1) 18]));
     input_fea = permute( input_fea(:,:,3:end), [2,1,3] );
     rgbvar = imread(fullfile(folderJpg,[filepathGt(i).name(1:end-4),'.jpg']));
     [gxpos1,gypos1] = gradient(input_fea(:,:,4));
     [gxpos2,gypos2] = gradient(input_fea(:,:,5));
     [gxpos3,gypos3] = gradient(input_fea(:,:,6));
     [gxnorm1,gynorm1] = gradient(input_fea(:,:,7));
     [gxnorm2,gynorm2] = gradient(input_fea(:,:,8));
     [gxnorm3,gynorm3] = gradient(input_fea(:,:,9));
     [gxtex11,gytex11] = gradient(input_fea(:,:,10));
     [gxtex12,gytex12] = gradient(input_fea(:,:,11));
     [gxtex13,gytex13] = gradient(input_fea(:,:,12));
     [gxtex21,gytex21] = gradient(input_fea(:,:,13));
     [gxtex22,gytex22] = gradient(input_fea(:,:,14));
     [gxtex23,gytex23] = gradient(input_fea(:,:,15));
     gxpos = (gxpos1+gxpos2+gxpos3)/3;
     gypos = (gypos1+gypos2+gypos3)/3;
     gxnorm = (gxnorm1+gxnorm2+gxnorm3)/3;
     gynorm = (gynorm1+gynorm2+gynorm3)/3;
     gxtex1 = (gxtex11+gxtex12+gxtex13)/3;
     gytex1 = (gytex11+gytex12+gytex13)/3;
     gxtex2 = (gxtex21+gxtex22+gxtex23)/3;
     gytex2 = (gytex21+gytex22+gytex23)/3;
%      normvar = (sum(input_var(:,:,7:9),3)/3);
%      tex1var = (sum(input_var(:,:,10:12),3)/3);
%      tex2var = (sum(input_var(:,:,13:15),3)/3);
%      posvar = (sum(input_var(:,:,3:6),3)/3);
     visvar = input_var(:,:,16);
     SecondFeature(:,:,1) = gxpos;
     SecondFeature(:,:,2) = gypos;
     SecondFeature(:,:,3) = gxnorm;
     SecondFeature(:,:,4) = gynorm;
     SecondFeature(:,:,5) = gxtex1;
     SecondFeature(:,:,6) = gytex1;
     SecondFeature(:,:,7) = gxtex2;
     SecondFeature(:,:,8) = gytex2;
     SecondFeature(:,:,9) = input_fea(:,:,16);
     SecondFeature(:,:,10) = rgb2gray(rgbvar)/255;
     SecondFeature(:,:,11) = visvar;
     SecondFeature(:,:,12) = input_fea(:,:,10);
     SecondFeature(:,:,13) = input_fea(:,:,11);
     SecondFeature(:,:,14) = input_fea(:,:,12);
     SecondFeature(:,:,15) = input_fea(:,:,13);
     SecondFeature(:,:,16) = input_fea(:,:,14);
     SecondFeature(:,:,17) = input_fea(:,:,15);
     for j = 1:8
         SecondFeature(:,:,j) = (SecondFeature(:,:,j)/(max(max(SecondFeature(:,:,j)))-min(min(SecondFeature(:,:,j)))))*2;
     end
     for k = 11:16
         SecondFeature(:,:,k) = (SecondFeature(:,:,k)/(max(max(SecondFeature(:,:,k)))-min(min(SecondFeature(:,:,k)))));
     end
     save(fullfile(folderNewFeature,[filepathGt(i).name(1:end-4),'.mat']),'SecondFeature');
end

     