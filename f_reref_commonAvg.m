function Data = f_reref_commonAvg(Data)
%
%
%%
    cfg = [];
    cfg.channel = 'all';
    cfg.reref = 'yes';
    cfg.refchannel = 'all';
    cfg.updatesens = 'yes';
    cfg.refmethod = 'avg';
    Data = ft_preprocessing(cfg, Data);
end