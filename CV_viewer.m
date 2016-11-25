CV_stds = [];
CV_ms = [];
for s=2:10
    for b = 2:10

        if exist(['stds/std_' num2str(s) '_' num2str(b) '.mat'], 'file')
            std = load(['stds/std_' num2str(s) '_' num2str(b) '.mat']);
            std = std.std;
            CV_stds = [CV_stds; std];
        else
            CV_stds = [CV_stds; zeros(1,10)];
        end
     
        if exist(['ms/ms_' num2str(s) '_' num2str(b) '.mat'], 'file')
            ms = load(['ms/ms_' num2str(s) '_' num2str(b) '.mat']);
            m = ms.ms;
            CV_ms = [CV_ms; m];
        else
            CV_ms = [CV_ms; zeros(1,10)];
        end
    end
end
