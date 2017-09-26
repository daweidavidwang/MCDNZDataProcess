function output = SpikeRemoval(input)

[Ny Nx Nc] = size(input);

medFiltImg = zeros(Ny, Nx, Nc);
meanImg = zeros(Ny, Nx, Nc);
stdImg = zeros(Ny, Nx, Nc);

for i = 1 : Nc
    medFiltImg(:, :, i) = colfilt(input(:, :, i), [3 3], 'sliding', @median);
    meanImg(:, :, i) = colfilt(input(:, :, i), [3 3], 'sliding', @mean);
    stdImg(:, :, i) = colfilt(input(:, :, i), [3 3], 'sliding', @std);
end

inds = abs(input - meanImg) > stdImg;
output = input;
output(inds) = medFiltImg(inds);
