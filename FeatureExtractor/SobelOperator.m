function [ output ] = SobelOperator( input )
%SobelOperator for gradient operation
%   http://blog.sina.com.cn/s/blog_836db8100101njly.html
% Author : David Wang
%This function only support 1 dimention input

hx=[-1 -2 -1;0 0 0 ;1 2 1];%生产sobel垂直梯度模板  
hy=hx';                    %生产sobel水平梯度模板 
gradx=filter2(hx,input,'same');
% figure(1)
gradx=abs(gradx); %计算图像的sobel垂直梯度  
% imagesc(gradx);
% figure(2)
grady=filter2(hy,input,'same'); 
grady=abs(grady);
% imagesc(grady);
grad=gradx+grady;
output = grad;
end

