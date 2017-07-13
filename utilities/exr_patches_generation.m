function [inputs, labels, set] = exr_patches_generation(size_input,size_label,stride,folder,mode,max_numPatches,batchSize)

featureNum = 16;
inputs  = zeros(size_input, size_input, featureNum, 1,'single');
labels  = zeros(size_label, size_label, 6, 1,'single');
count   = 0;
padding = abs(size_input - size_label)/2;

ext               =  {'*.exr','*.mat'};
filepathsGt           =  [];
filepathsData           =  [];

folderGt = fullfile(folder,'gt');
folderData = fullfile(folder,'data');
for i = 1 : length(ext)
    filepathsGt = cat(1,filepathsGt, dir(fullfile(folderGt, ext{i})));
    filepathsData = cat(1,filepathsData, dir(fullfile(folderData, ext{i})));
end

for i = 1 : length(filepathsGt)
    image = exrread(fullfile(folderGt,filepathsGt(i).name));

    input_exr = exrread( fullfile(folderData,[filepathsGt(i).name(1:end-4),'_MC_0016.exr'] ) );
    input_im = load( fullfile(folderData,[filepathsGt(i).name(1:end-4),'.mat'] ) );
    input_im = single(reshape(input_im.doublefeature,[size(input_exr,2) size(input_exr,1) 18]));
    input_im = permute( input_im(:,:,3:end), [2,1,3] );
    input_im(:,:,1:3) = input_exr;
    clear input_exr;
    
    image = cat(3,image,input_im(:,:,1:3));%将input图像放入GT中，用于残差的相加操作
    
    for j = 1:1
        image_aug = data_augmentation(image, j);  % augment data
        input_im_aug =  data_augmentation(input_im, j);  % augment data
        im_label  = im2single(image_aug); % single
        im_data = im2single(input_im_aug);
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
    end
end

inputs = inputs(:,:,:,1:(size(inputs,4)-mod(size(inputs,4),batchSize)));
labels = labels(:,:,:,1:(size(labels ,4)-mod(size(labels ,4),batchSize)));
% tmp = shave(inputs,[padding,padding]); %%% residual image patches; pay attention to this!!!
% labels = tmp(:,:,3:5,:) - labels;
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

% normalize.mean = zeros(16,1);
% normalize.std = zeros(16,1);
% for i = 1:16
%     tmp = inputs(:,:,i,:);
%     normalize.mean(i,1) = mean(tmp(:));
%     normalize.std(i,1) = std(tmp(:));
%     inputs(:,:,i,:) = ( inputs(:,:,i,:) - mean(tmp(:)) )/std(tmp(:));
% end
% save('normalize.mat','normalize');














