function Data = f_filter_powerlinenoise(Data, PowerLineNoiseFreq, BandpassFreq, range)
%
%
%% Perform Band Stop filtering to remove power line noise
    cfg = [];
    cfg.detrend = 'no';
    cfg.demean = 'no';
    cfg.baselinewindow = 'all';
    cfg.bsfilter = 'yes';
    cfg.bsfiltord = 3;
    LineNoiseFreqCenter = PowerLineNoiseFreq : PowerLineNoiseFreq : floor(BandpassFreq(2)/PowerLineNoiseFreq)*PowerLineNoiseFreq;
    LineNoiseFreqCenter = LineNoiseFreqCenter';
    BandStopFreq = [LineNoiseFreqCenter-range, LineNoiseFreqCenter+range];
    BandStopFreq(BandStopFreq>BandpassFreq(2)) = BandpassFreq(2);
    BandStopFreq(BandStopFreq<BandpassFreq(1)) = BandpassFreq(1);
    cfg.bsfreq = BandStopFreq; % power-line frequency
    Data = ft_preprocessing(cfg, Data);
end