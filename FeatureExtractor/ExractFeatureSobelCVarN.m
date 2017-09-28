folderGT = 'I:\DatasetWithSecondFeature_aug3\GT';
folderMat = 'I:\DatasetWithSecondFeature_aug3\4SPP\Feature';
%folderJpg = 'G:\DatasetWithSecondFeature_aug3\64SPP\varexr\jpg';
folderNewFeature = 'I:\DatasetWithSecondFeature_aug3\4SPP\SobelCVarN';
filepathGt = [];
alpha = 0.5636;
ext               =  {'*.exr'};
for i = 1 : length(ext)
    filepathGt = cat(1,filepathGt, dir(fullfile(folderGT, ext{i})));
end

for i = 1 : length(filepathGt)
     image = exrread(fullfile(folderGT,filepathGt(i).name));
     input_im = load( char(fullfile(folderMat,[filepathGt(i).name(1:end-4),'.mat'] )) );
     %rgbvar = exrread(fullfile(folderJpg,[filepathGt(i).name(1:end-4),'.exr']));
     input_var = single(reshape(input_im.Var,[size(image,2) size(image,1) 18]));
     SobelCVarN  = zeros(size(image,1), size(image,2), 10, 'single');
     input_var = permute( input_var(:,:,3:end), [2,1,3] );
     input_fea = single(reshape(input_im.FirstFeature,[size(image,2) size(image,1) 18]));
     input_fea = permute( input_fea(:,:,3:end), [2,1,3] );
     gpos1 = SobelOperator(input_fea(:,:,4));
     gpos2 = SobelOperator(input_fea(:,:,5));
     gpos3 = SobelOperator(input_fea(:,:,6));
     gnorm1 = SobelOperator(input_fea(:,:,7));
     gnorm2 = SobelOperator(input_fea(:,:,8));
     gnorm3 = SobelOperator(input_fea(:,:,9));
     gtex11 = SobelOperator(input_fea(:,:,10));
     gtex12 = SobelOperator(input_fea(:,:,11));
     gtex13 = SobelOperator(input_fea(:,:,12));
     gtex21 = SobelOperator(input_fea(:,:,13));
     gtex22 = SobelOperator(input_fea(:,:,14));
     gtex23 = SobelOperator(input_fea(:,:,15));
     gpos = (gpos1+gpos2+gpos3)/3;
     gnorm = (gnorm1+gnorm2+gnorm3)/3;
     gtex1 = (gtex11+gtex12+gtex13)/3;
     gtex2 = (gtex21+gtex22+gtex23)/3;
     colorVar = (sum(input_var(:,:,1:3),3)/3);
     normvar = (sum(input_var(:,:,7:9),3)/3);
     tex1var = (sum(input_var(:,:,10:12),3)/3);
     tex2var = (sum(input_var(:,:,13:15),3)/3);
     posvar = (sum(input_var(:,:,4:6),3)/3); % something wrong happened
     SobelCVarN(:,:,1) = gpos;
     SobelCVarN(:,:,2) = gnorm;
     SobelCVarN(:,:,3) = gtex1;
     SobelCVarN(:,:,4) = gtex2;
     SobelCVarN(:,:,5) = input_fea(:,:,16);
     SobelCVarN(:,:,6) = tanh(alpha*colorVar);
     SobelCVarN(:,:,7) = posvar;
     SobelCVarN(:,:,8) = normvar;
     SobelCVarN(:,:,9) = tex1var;
     SobelCVarN(:,:,10) = tex2var;
     for j = 1:5
         SobelCVarN(:,:,j) = (SobelCVarN(:,:,j)/(max(max(SobelCVarN(:,:,j)))-min(min(SobelCVarN(:,:,j)))));
     end
     for k = 7:10
         SobelCVarN(:,:,k) = (SobelCVarN(:,:,k)/(max(max(SobelCVarN(:,:,k)))-min(min(SobelCVarN(:,:,k)))));
     end
     result(i).name = filepathGt(i).name;
     result(i).ExtractFeatureTime =  etime(clock,t0);
     save(fullfile(folderNewFeature,[filepathGt(i).name(1:end-4),'.mat']),'SobelCVarN');
end

     