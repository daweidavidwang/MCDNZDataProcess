%HDRVDP 全数据统计
folder = 'G:\DatasetWithSecondFeature_aug2';
folderpa = 'G:\DatasetWithSecondFeature_aug2\GT';
% distribution = zeros(2000);
ext               =  {'*.exr'};
filepathsGt           =  [];
folderGt = folderpa;
spp = {'4SPP','8SPP','16SPP','32SPP','64SPP'};
jpgName = ['_MC_0004.exr';'_MC_0008.exr';'_MC_0016.exr';'_MC_0032.exr';'_MC_0064.exr'];
size_input = 64;
size_label = 64;
stride = 32;
padding = 0;
count = 1;
for i = 1 : length(ext)
    filepathsGt = cat(1,filepathsGt, dir(fullfile(folderGt, ext{i})));
end
for i = 1 : length(filepathsGt)
    for index = 1:length(spp) 
        image = exrread(fullfile(folderGt,filepathsGt(i).name))  ;
        folderData = fullfile(folder,spp(index));
        folderData = fullfile(folderData,'exr');
        tmp = fullfile(folderData,[filepathsGt(i).name(1:end-4),jpgName(index,:)] );
        input_jpg =  exrread( char(tmp) );
        im_label  = image; % single
        im_data = input_jpg;
            [hei,wid,~] = size(im_label);
            for x = 1 : stride : (hei-size_input+1)
                for y = 1 :stride : (wid-size_input+1)
                    subim_input = im_data(x+padding : x+padding+size_input-1, y+padding : y+padding+size_input-1,:);
                    subim_label = im_label(x+padding : x+padding+size_label-1, y+padding : y+padding+size_label-1,:);
                        ataninput = subim_input(:,:,1:3);
                        atanlabel = subim_label(:,:,1:3);
                        ataninput = 0.2989*ataninput(:,:,1)+0.5870*ataninput(:,:,2)+0.1140*ataninput(:,:,3);
                        atanlabel = 0.2989*atanlabel(:,:,1)+0.5870*atanlabel(:,:,2)+0.1140*atanlabel(:,:,3);
                        res = hdrvdp(ataninput, atanlabel , 'luminance', 30, { 'surround_l', 13 } );
                        f = fspecial('gaussian',[3 3],5); %高斯模板
                        P_map = imfilter(res.P_map,f,'same'); % 滤波
                        distribution(count) = max(max(P_map));
                        count = count+1;
                end
            end
        end
end
    
    
