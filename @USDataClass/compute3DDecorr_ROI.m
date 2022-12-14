function compute3DDecorr_ROI( obj )
    %COMPUTE3DDECORR Summary of this function goes here
    %%
    % *Define Guassian Window* 
    x_range_length = size(obj.x_range,2);
    y_range_length = size(obj.y_range,2);
    z_range_length = size(obj.z_range,2);
    sigx = obj.windowSigma/obj.dx;
    sigy = obj.windowSigma/obj.dy;
    sigz = obj.windowSigma/obj.dz;
    x_mid = ceil(x_range_length/2);
    y_mid = ceil(y_range_length/2);
    z_mid = ceil(z_range_length/2);
    sigfaz = x_range_length/(2*pi*sigx);
    sigfra = y_range_length/(2*pi*sigy);
    sigfel = z_range_length/(2*pi*sigz); 
    padAmtx = ceil(sigx)*3;
    padAmty = ceil(sigy)*3;
    padAmtz = ceil(sigz)*3;
    padArr = [padAmtx,padAmty,padAmtz];
    %xmask = exp(-(((1:x_range_length)-x_mid).^2)/2/sigfaz^2);
    %ymask = exp(-(((1:y_range_length)-y_mid).^2)/2/sigfra^2);
    %zmask = exp(-(((1:z_range_length)-z_mid).^2)/2/sigfel^2);
    xmask = 1/(sigx*sqrt(2*pi))*exp(-((((1:x_range_length)-x_mid)/(sigx)).^2)/2);
    ymask = 1/(sigy*sqrt(2*pi))*exp(-((((1:y_range_length)-y_mid)/(sigy)).^2)/2);
    zmask = 1/(sigz*sqrt(2*pi))*exp(-((((1:z_range_length)-z_mid)/(sigz)).^2)/2);
    
    [z_mask_mat,y_mask_mat,x_mask_mat] = ndgrid(zmask,ymask,xmask); 
    xLen = (ceil(sigx)*7); xMid = floor(xLen/2)+1;
    yLen = (ceil(sigy)*7); yMid = floor(xLen/2)+1;
    zLen = (ceil(sigz)*7); zMid = floor(xLen/2)+1;
    
    xmask_2 = 1/(sigx*sqrt(2*pi))*exp(-((((1:xLen)-xMid)/(sigx)).^2)/2);
    ymask_2 = 1/(sigy*sqrt(2*pi))*exp(-((((1:yLen)-yMid)/(sigy)).^2)/2);
    zmask_2 = 1/(sigz*sqrt(2*pi))*exp(-((((1:zLen)-zMid)/(sigz)).^2)/2);
    
    [z_mask_mat_2,y_mask_mat_2,x_mask_mat_2] = ndgrid(zmask_2,ymask_2,xmask_2); 
    
    maskfilt = (fftshift(x_mask_mat.*y_mask_mat.*z_mask_mat)); 
    
    %imagesc(maskfilt(:,:,1))
    % *compute windowed ibs and autocorr01*
    %compute ibs and autocorr before windowing
    obj.ibs = abs(obj.rawData_cart).^2;
    obj.autocorr01 = obj.rawData_cart(:,:,:,1:(end-1)).*conj(obj.rawData_cart(:,:,:,2:end));
    % set NaN values to small number 
    obj.autocorr01(find(isnan(obj.autocorr01))) = 0;
    obj.ibs(find(isnan(obj.ibs))) = 0;
    %compute windowed ibs
    for currVolume = 1:size(obj.ibs,4)
      obj.ibs(:,:,:,currVolume) = abs(ifftn(fftn(obj.ibs(:,:,:,currVolume)).*maskfilt));
    end
    %compute autcorrelation and decorrelation
    for currVolume = 1:(size(obj.ibs,4)-1)
        obj.autocorr01(:,:,:,currVolume) = abs(ifftn(fftn(obj.autocorr01(:,:,:,currVolume)).*maskfilt));
    end
    for currVolume = 1:(size(obj.ibs,4)-1)
        R00 = obj.ibs(:,:,:,currVolume);
        R11 = obj.ibs(:,:,:,currVolume+1);
        B2 = R00.*R11;
        R01 = (obj.autocorr01(:,:,:,currVolume)).^2;
        tau = 10^3/(obj.interFrameTime);
        BMean = sum((obj.ROIMap.*B2),'all')/sum(obj.ROIMap(:));
        obj.decorr(:,:,:,currVolume) = 2*(B2-R01)./(B2 + mean(B2(:)))/tau;
    end
    % set values outside of volume to small number 
    obj.autocorr01(find(abs(obj.rawData_cart(:,:,:,1:(end-1))) == 0)) = 0;
    obj.ibs(find(abs(obj.rawData_cart(:,:,:,1:(end-1))) == 0)) = 0;
    obj.decorr(find(abs(obj.rawData_cart(:,:,:,1:(end-1))) == 0)) = 0;
end

