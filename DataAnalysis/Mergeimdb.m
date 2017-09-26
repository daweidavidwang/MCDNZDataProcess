% a01 = load('E:\DataProcess\model_MC_Res_Bnorm_Adam\imdb1.mat');
% a02 = load('E:\DataProcess\model_MC_Res_Bnorm_Adam\imdb2.mat');
% a03 = load('E:\DataProcess\model_MC_Res_Bnorm_Adam\imdb3.mat');
% a04 = load('E:\DataProcess\model_MC_Res_Bnorm_Adam\imdb4.mat');
a05 = load('E:\DataProcess\model_MC_Res_Bnorm_Adam\imdb5.mat');

inputs = cat(4,a01.inputs,a02.inputs,a03.inputs,a04.inputs,a05.inputs);
labels = cat(4,a01.labels,a02.labels,a03.labels,a04.labels,a05.labels);
set = cat(2,a01.set,a02.set,a03.set,a04.set,a05.set);
% inputs = cat(4,a01.inputs,a02.inputs);
% labels = cat(4,a01.labels,a02.labels);
% set = cat(2,a01.set,a02.set);
order = randperm(size(inputs,4));
clear a01;
clear a02;
clear a03;
clear a04;
clear a05;
inputs = inputs(:,:,:,order);
labels = labels(:,:,:,order);
set = set(:,order);

save('D:\imdb.mat','inputs','labels','set','-v7.3');