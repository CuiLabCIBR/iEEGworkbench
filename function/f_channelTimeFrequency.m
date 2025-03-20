function TFRdata = f_channelTimeFrequency(Data, foi, coi)
%
%
%
%%
    % select channel
    cfg = [];
    cfg.channel = {coi};
    Data = ft_preprocessing(cfg, Data);
    TFRdata = Data;
    % creat new channel label
    label = cell(length(foi), 1);
    for nChan = 1:length(foi)
        label{nChan} = [num2str(foi(nChan)), 'Hz'];
    end
    TFRdata.label = label;
    % calculate the time frequency representation across trial
    for nTrial = 1:length(Data.trial)
        % one trial data
        Data_ot = Data;
        Data_ot.sampleinfo = Data.sampleinfo(nTrial, :);
        Data_ot.trial = Data.trial(nTrial);
        time_older = Data_ot.time{nTrial};
        time = time_older-time_older(1);
        Data_ot.time = {time};
        % calculate time frequency representation
        cfg = [];
        cfg.channel = 'all';
        cfg.method  = 'wavelet';
        cfg.output  = 'pow';
        cfg.foi = foi;
        cfg.toi = time;
        TFRwave = ft_freqanalysis(cfg, Data_ot);
        % construct TFR data
        TFRsignal = squeeze(TFRwave.powspctrm(1,  :,  :));
        TFRdata.trial{nTrial} = TFRsignal;
        TFRdata.time{nTrial} = time_older;
        % check
        if size(TFRsignal, 2) ~= length(time_older)
            error('Time resolution error!');
        end
    end
end