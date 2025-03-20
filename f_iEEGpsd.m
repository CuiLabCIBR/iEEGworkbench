function PSD = f_iEEGpsd(Data, freqRange)
    cfg = [];
    cfg.output  = 'pow';
    cfg.channel = 'all';
    cfg.method  = 'mtmfft';
    cfg.foi = freqRange;
    cfg.taper   = 'hanning';
    PSD = ft_freqanalysis(cfg, Data);
    PSD.powspctrm = log10(PSD.powspctrm);
end