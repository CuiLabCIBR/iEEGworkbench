function Data = f_detrend_demean(Data)
%
%
%%
    % Perform Bandpass Filtering to Extract Signals of Interesting Frequency Band
    cfg = [];
    cfg.detrend = 'yes';
    cfg.demean = 'yes';
    Data = ft_preprocessing(cfg, Data);
end