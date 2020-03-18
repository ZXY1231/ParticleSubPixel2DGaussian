x = 0:0.1:55;
y = 0:0.1:50;
[X, Y] = meshgrid(x,y);
XYdata = zeros(size(X,1),size(Y,2),2);
XYdata(:,:,1) = X;
XYdata(:,:,2) = Y;
Intensities = Gaussian2DFunction(test_para, XYdata);
figure(1111)
mesh(Intensities)

function fun_2D = Gaussian2DFunction(paras, xy)
    %  https://en.wikipedia.org/wiki/Gaussian_function
    % add theta(rotation) argument
    center_x = paras(1);
    center_y = paras(2);
    sigma_x = paras(3);
    sigma_y = paras(4);
    theta = paras(5);
    factor = paras(6);

    x = xy(:,:,1) - center_x;
    y = xy(:,:,2) - center_y;

    x_rot = x*cos(theta) - y*sin(theta);
    y_rot = x*sin(theta) + y*cos(theta);
    
    pre_fun = (x_rot/sigma_x).^2 + (y_rot/sigma_y).^2;
    fun_2D = factor*exp(-pre_fun/2);
    %  location = round(sum(x))/leng + n*round(sum(y)/leng-1);

end
