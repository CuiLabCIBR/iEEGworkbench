function iEEGData = f_iEEGplot_iEEGnomScale(iEEGData)
%
%
%
    VoltageMean = cellfun(@(x) mean(x, 2), iEEGData.trial, 'UniformOutput', false);
    iEEGData.trial = cellfun(@(x, y) x-y, iEEGData.trial, VoltageMean, 'UniformOutput', false);
    VoltageStd = cellfun(@(x) std(x, 0, 2), iEEGData.trial, 'UniformOutput', false);
    VoltageMedianStd = cellfun(@median, VoltageStd, 'UniformOutput', false);
    iEEGData.trial = cellfun(@(x, y) x./y, iEEGData.trial, VoltageMedianStd, 'UniformOutput', false);
end