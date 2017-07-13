function [inputs, labels, set] = mat_patches_generationLDR(size_input,size_label,stride,folder,mode,max_numPatches,batchSize)

featureNum = 16;
inputs  = zeros(size_input, size_input, featureNum, 1,'single');
labels  = zeros(size_label, size_label, 6, 1,'single');
count   = 0;
padding = abs(size_input - size_label)/2;

ext               =  {'*.mat','*.jpg'};
filepathsGt           =  [];
filepathsData           =  [];

folderGt = fullfile(folder,'gtv','jpg');
folderData = fullfile(folder,'data');

% spp = {'4SPP','8SPP','16SPP','32SPP','64SPP'};
% jpgName = ['_MC_0004.jpg';'_MC_0008.jpg';'_MC_0016.jpg';'_MC_0032.jpg';'_MC_0064.jpg'];
spp = {'4SPP','8SPP','16SPP','32SPP','64SPP','96SPP'};
jpgName = ['_MC_0004.jpg';'_MC_0008.jpg';'_MC_0016.jpg';'_MC_0032.jpg';'_MC_0064.jpg';'_MC_0096.jpg'];

for i = 1 : length(ext)
    filepathsGt = cat(1,filepathsGt, dir(fullfile(folderGt, ext{i})));
    filepathsData = cat(1,filepathsData, dir(fullfile(folderData, ext{i})));
end

for i = 1 : length(filepathsGt)
    
    
    for index = 1:length(spp) 
        image = im2single( imread(fullfile(folderGt,filepathsGt(i).name))  );
        folderData = fullfile(folder,spp(index));
        folderDataFeature = fullfile(folderData,'Feature');
        folderData = fullfile(folderData,'jpg');
        tmp = fullfile(folderData,[filepathsGt(i).name(1:end-4),jpgName(index,:)] );
        input_jpg = im2single( imread( char(tmp) ));
        input_im = load( char(fullfile(folderData,[filepathsGt(i).name(1:end-4),'.mat'] )) );
        input_im = single(reshape(input_im.doublefeature,[size(input_jpg,2) size(input_jpg,1) 18]));
        input_im = permute( input_im(:,:,3:end), [2,1,3] );
        
        input_im(:,:,1:3) = input_jpg;
        for k = 4:16
            %             tmp = input_im(:,:,j);
            %             input_im(:,:,j) = (input_im(:,:,j) - mean(tmp(:)))/std(tmp(:));
            input_im(:,:,k) = ( input_im(:,:,k) - min(min(input_im(:,:,k))) )/( max(max(input_im(:,:,k))) - min(min(input_im(:,:,k))) );
        end
        
        image = cat(3,image,input_im(:,:,1:3));%��inputͼ�����GT�У����ڲв����Ӳ���
       
        for j = 1:1
            image_aug = data_augmentation(image, j);  % augment data
            input_im_aug =  data_augmentation(input_im, j);  % augment data
%             clear image; clear input_im;
            im_label  = im2single(image_aug); % single
            im_data = im2single(input_im_aug);
%             clear image_aug; clear input_im_aug;
            [hei,wid,~] = size(im_label);
            for x = 1 : stride : (hei-size_input+1)
                for y = 1 :stride : (wid-size_input+1)
                    subim_input = im_data(x+padding : x+padding+size_input-1, y+padding : y+padding+size_input-1,:);
                    subim_label = im_label(x+padding : x+padding+size_label-1, y+padding : y+padding+size_label-1,:);
                    count       = count+1;
                    inputs(:, :, :, count)   = subim_input;
                    labels(:, :, :, count) = subim_label;
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















