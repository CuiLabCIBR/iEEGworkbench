function freqPSD = f_PSD(Data, freqList)
    cfg = [];
    cfg.output    = 'pow';
    cfg.channel   = 'all';
    cfg.method    = 'mtmfft';
    cfg.taper     = 'hanning';
    cfg.pad = 'nextpow2';
    cfg.foi = freqList;
    freqPSD = ft_freqanalysis(cfg, Data);
end