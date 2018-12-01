function hist_list = PlotHistogram(name,input_img)
hist_list = zeros(1,256);
for i=1:256
    for j=1:256
        idx = floor(double(input_img(i,j)));
        idx = idx+1;
        hist_list(idx) = hist_list(idx) + 1;
    end
end

figure('name',name);
bar(hist_list);
end