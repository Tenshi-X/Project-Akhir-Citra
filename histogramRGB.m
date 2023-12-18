function histogramRGB(I)
if(size(I,3)~=3)
    imhist(I);
end
if(size(I,3)==3)
    nBins=256;
    rHist = imhist(I(:,:,1), nBins);
    gHist = imhist(I(:,:,2), nBins);
    bHist = imhist(I(:,:,3), nBins);
    
    h(1) = area(1:nBins, rHist, 'FaceColor','r'); hold on;
    h(2) = area(1:nBins, gHist, 'FaceColor','g'); hold on;
    h(3) = area(1:nBins, bHist, 'FaceColor','b'); hold on;
end