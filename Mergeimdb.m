a01 = load('D:\model_MC_Res_Bnorm_Adam\imdb01NF.mat');
a02 = load('D:\model_MC_Res_Bnorm_Adam\imdb02NF.mat');
a03 = load('D:\model_MC_Res_Bnorm_Adam\imdb03NF.mat');
a04 = load('D:\model_MC_Res_Bnorm_Adam\imdb04NF.mat');
a05 = load('D:\model_MC_Res_Bnorm_Adam\imdb05NF.mat');

inputs = cat(4,a01.inputs,a02.inputs,a03.inputs,a04.inputs,a05.inputs);
labels = cat(4,a01.labels,a02.labels,a03.labels,a04.labels,a05.labels);
set = cat(2,a01.set,a02.set,a03.set,a04.set,a05.set);
order = randperm(size(inputs,4));
inputs = inputs(:,:,:,order);
labels = labels(:,:,:,order);
set = set(:,order);

save('D:\model_MC_Res_Bnorm_Adam\imdb.mat','inputs','labels','set','-v7.3');