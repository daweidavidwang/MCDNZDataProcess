folder = 'G:\DatasetWithSecondFeature_aug3\32SPP\exr';
LowPassFolder = 'G:\DatasetWithSecondFeature_aug3\32SPP\exr\lowpass50';
HighPassFolder = 'G:\DatasetWithSecondFeature_aug3\32SPP\exr\highpass50';
ext               =  {'*.exr'};
filepaths           =  [];
for i = 1 : length(ext)
    filepaths = cat(1,filepaths, dir(fullfile(folder, ext{i})));
end
for p = 1 : length(filepaths)
    input = exrread(fullfile(folder,filepaths(p).name));
    fourier = fft2(input);
    fourier = fftshift(fourier);
    [M,N,P]=size(fourier);  
    result = zeros(M,N,P);
    nn=2;   %%filer order
    m=floor(M/2); n=floor(N/2);  
    d0 = 50;
    %高通滤波   
    for k=1:P
        for i=1:M  
            for j=1:N  
                d=sqrt((i-m)^2+(j-n)^2);  
                h=1/(1+0.414*(d0/d)^(2*nn));% 计算传递函数  
                result(i,j,k)=h*fourier(i,j,k);  %#ok<*SAGROW>
            end  
        end
    end
    result = ifftshift(result);
    result = ifft2(result);
    Realhighpass = real(result);
    Reallowpass = input - Realhighpass;
    exrwrite(Realhighpass,fullfile(HighPassFolder,filepaths(p).name));
    exrwrite(Reallowpass,fullfile(LowPassFolder,filepaths(p).name));
    clear result;
    clear input;
end