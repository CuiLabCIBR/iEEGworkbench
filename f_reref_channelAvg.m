function Data = f_reref_channelAvg(Data, chanGroups)
%
%
%%
    chanLabels = Data.label;
    [groupLabels, ~, ia] = unique(chanGroups);
    channelAvgRef = cell(1, length(groupLabels));
    for nGroup = 1:length(groupLabels)
        groupChans = chanLabels(ia == nGroup);
        cfg = [];
        cfg.channel = groupChans;
        cfg.reref = 'yes';
        cfg.refchannel = 'all';
        cfg.updatesens = 'yes';
        cfg.refmethod = 'avg';
        channelAvgRef{nGroup} = ft_preprocessing(cfg, Data);
    end
    cfg = [];
    cfg.appendsens = 'yes';
    Data = ft_appenddata(cfg, channelAvgRef{:});% combine the data into one data structure
end