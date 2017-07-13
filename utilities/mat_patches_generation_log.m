function [inputs, labels, set] = mat_patches_generation_log(size_input,size_label,stride,folder,mode,max_numPatches,batchSize)

featureNum = 16;
inputs  = zeros(size_input, size_input, featureNum, 1,'single');
labels  = zeros(size_label, size_label, 6, 1,'single');
count   = 0;
padding = abs(size_input - size_label)/2;

ext               =  {'*.mat','*.exr'};
filepathsGt           =  [];
filepathsData           =  [];

folderGt = fullfile(folder,'gtp');
folderData = fullfile(folder,'data');

spp = {'16SPP','32SPP','64SPP'};
exrName = ['_MC_0016.exr';'_MC_0032.exr';'_MC_0064.exr'];

for i = 1 : length(ext)
    filepathsGt = cat(1,filepathsGt, dir(fullfile(folderGt, ext{i})));
    filepathsData = cat(1,filepathsData, dir(fullfile(folderData, ext{i})));
end

for i = 1 : length(filepathsGt)
    
    
    for index = 1:length(spp) 
        image = exrread(fullfile(folderGt,filepathsGt(i).name));
        folderData = fullfile(folder,spp(index));
        folderDataFeature = fullfile(folderData,'Feature');
        tmp = fullfile(folderData,[filepathsGt(i).name(1:end-4),exrName(index,:)] );
        input_exr = exrread( char(tmp) );
        input_im = load( char(fullfile(folderDataFeature,[filepathsGt(i).name(1:end-4),'.mat'] )) );
        input_im = single(reshape(input_im.doublefeature,[size(input_exr,2) size(input_exr,1) 18]));
        input_im = permute( input_im(:,:,3:end), [2,1,3] );
        input_im(:,:,1:3) = log(input_exr+1);
        clear input_exr;
        %input_im = log(1+input_im);
        for k = 4:16
            input_im(:,:,k) = ( input_im(:,:,k) - min(min(input_im(:,:,k))) )/( max(max(input_im(:,:,k))) - min(min(input_im(:,:,k))) );
        end
        image = cat(3,image,input_im(:,:,1:3));%将normalize后的input图像放入GT中，用于残差的相加操作
        for j = 1:1
            image_aug = data_augmentation(image, j);  % augment data
            input_im_aug =  data_augmentation(input_im, j);  % augment data
            clear image; clear input_im;
            im_label  = image_aug; % single
            im_data = input_im_aug;
            clear image_aug; clear input_im_aug;
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















