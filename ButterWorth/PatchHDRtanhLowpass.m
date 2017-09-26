function [inputs, labels, set] = PatchHDRtanhLowpass(size_input,size_label,stride,folder,folderpa,mode,max_numPatches,batchSize)
PatchSelect = 0;
featureNum = 3;
inputs  = zeros(size_input, size_input, featureNum, 1,'single');
labels  = zeros(size_label, size_label, 6, 1,'single');
count   = 0;
padding = abs(size_input - size_label)/2;

ext               =  {'*.mat','*.exr'};
filepathsGt           =  [];

folderGt = folderpa;

spp = {'4SPP','8SPP','16SPP','32SPP','64SPP'};
jpgName = ['_MC_0004.exr';'_MC_0008.exr';'_MC_0016.exr';'_MC_0032.exr';'_MC_0064.exr'];
% spp = {'16SPP'};
% jpgName = ['_MC_0016.exr'];
for i = 1 : length(ext)
    filepathsGt = cat(1,filepathsGt, dir(fullfile(folderGt, ext{i})));
end

for i = 1 : length(filepathsGt)
    
    
    for index = 1:length(spp) 
        image = exrread(fullfile(folder,'GT','lowpass50',filepathsGt(i).name))  ;
        folderData = fullfile(folder,spp(index));
        %folderDataFeature = fullfile(folderData,'NewFeature');
        folderData = fullfile(folderData,'exr','lowpass50');
        tmp = fullfile(folderData,[filepathsGt(i).name(1:end-4),jpgName(index,:)] );
        input_jpg =  exrread( char(tmp) );
        %featureinput = load( char(fullfile(folderDataFeature,[filepathsGt(i).name(1:end-4),'.mat'] )) );
        input_jpg = tanh(0.5636*input_jpg);
        input_im = input_jpg;
        
        image = cat(3,image,input_im(:,:,1:3));%将input图像放入GT中，用于残差的相加操作
       
        for j = 1:4
            image_aug = data_augmentation(image, j);  % augment data
            input_im_aug =  data_augmentation(input_im, j);  % augment data
%             clear image; clear input_im;
            im_label  = image_aug; % single
            im_data = input_im_aug;
%             clear image_aug; clear input_im_aug;
            [hei,wid,~] = size(im_label);
            for x = 1 : stride : (hei-size_input+1)
                for y = 1 :stride : (wid-size_input+1)
                    subim_input = im_data(x+padding : x+padding+size_input-1, y+padding : y+padding+size_input-1,:);
                    subim_label = im_label(x+padding : x+padding+size_label-1, y+padding : y+padding+size_label-1,:);
                    if PatchSelect
                        ataninput = atanh(subim_input(:,:,1:3))/0.5636;
                        atanlabel = subim_label(:,:,1:3);
                        ataninput = 0.2989*ataninput(:,:,1)+0.5870*ataninput(:,:,2)+0.1140*ataninput(:,:,3);
                        atanlabel = 0.2989*atanlabel(:,:,1)+0.5870*atanlabel(:,:,2)+0.1140*atanlabel(:,:,3);
                        res = hdrvdp(ataninput, atanlabel , 'luminance', 30, { 'surround_l', 13 } );
                        f = fspecial('gaussian',[3 3],5); %高斯模板
                        P_map = imfilter(res.P_map,f,'same'); % 滤波
                        if max(max(P_map))>0.1
                            count       = count+1;
                            inputs(:, :, :, count)   = subim_input;
                            labels(:, :, :, count) = subim_label;
                        end
                    else
                        count       = count+1;
                        inputs(:, :, :, count)   = subim_input;
                        labels(:, :, :, count) = subim_label;
                    end
                end
            end
            clear im_label;clear im_data; clear subim_input; clear subim_label;
        end
    end
    
    
end


inputs = inputs(:,:,:,1:(size(inputs,4)-mod(size(inputs,4),batchSize)));
labels = labels(:,:,:,1:(size(labels ,4)-mod(size(labels ,4),batchSize)));
order  = randperm(size(inputs,4));
inputs = inputs(:, :, :, order);
labels = labels(:, :, :, order);
set    = uint8(ones(1,size(inputs,4)));
if mode == 1
    set = uint8(2*ones(1,size(inputs,4)));
end
disp('-------Original Datasize-------')
disp(size(inputs,4));
subNum = min(size(inputs,4),max_numPatches);
inputs = inputs(:,:,:,1:subNum);
labels = labels(:,:,:,1:subNum);
set    = set(1:subNum);
disp('-------Now Datasize-------')
disp(size(inputs,4));















