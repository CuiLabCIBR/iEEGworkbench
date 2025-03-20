function zeroChans = f_rmBadChan_findZeroChannels(Data)

%%
    trialNum = length(Data.trial);
    chanNum = length(Data.label);
    zeroChans = {};
    for ii_trial = 1:trialNum
        signals = Data.trial{ii_trial};
        signals_diff = sum(abs(diff(signals, 1, 2)), 2);
        signals_diff = signals_diff./mean(signals_diff);
        for ii_chan = 1:chanNum
            signals_diff_aim = signals_diff(ii_chan);
            signals_diff_temp = signals_diff;
            signals_diff_temp(ii_chan) = [];
            if signals_diff_aim<= 0.001 * mean(signals_diff_temp)
                zeroChans = [zeroChans, Data.label(ii_chan)];
            end
        end
    end
    zeroChans = unique(zeroChans);
end