function Data = f_reref_seegLaplace(Data, chanGroups)
%
%
%%
    chanLabels = Data.label;
    [groupLabels, ~, ia] = unique(chanGroups);
    NN = 0;
    for nGroup = 1:length(groupLabels)
        groupChans = chanLabels(ia == nGroup);
        chanNum = zeros(1, length(groupChans));
        for nChan = 1:length(groupChans)
            chanNumStr = f_strsplit(groupChans{nChan}, groupLabels{nGroup});
            chanNum(nChan) = str2num(chanNumStr{1});
        end
        Index1 = find(diff(chanNum)>1);
        if isempty(Index1)
            NN = NN + 1;
            if length(groupChans)>2
                cfg = [];
                cfg.channel = groupChans;
                cfg.reref = 'yes';
                cfg.refchannel = 'all';
                cfg.updatesens = 'yes';
                cfg.refmethod = 'laplace';
                seegLaplace{NN} = ft_preprocessing(cfg, Data);
            else
                cfg = [];
                cfg.channel = groupChans;
                cfg.reref = 'yes';
                cfg.refchannel = 'all';
                cfg.updatesens = 'yes';
                cfg.refmethod = 'avg';
                seegLaplace{NN} = ft_preprocessing(cfg, Data);
            end
        else
            Index2 = [0, Index1, length(groupChans)];
            for nIndex = 1:length(Index2)-1
                selectChans = groupChans(Index2(nIndex)+1:Index2(nIndex+1));
                NN = NN + 1;
                if length(selectChans)>2
                    cfg = [];
                    cfg.channel = selectChans;
                    cfg.reref = 'yes';
                    cfg.refchannel = 'all';
                    cfg.updatesens = 'yes';
                    cfg.refmethod = 'laplace';
                    seegLaplace{NN} = ft_preprocessing(cfg, Data);
                else
                    cfg = [];
                    cfg.channel = selectChans;
                    cfg.reref = 'yes';
                    cfg.refchannel = 'all';
                    cfg.updatesens = 'yes';
                    cfg.refmethod = 'avg';
                    seegLaplace{NN} = ft_preprocessing(cfg, Data);
                end
            end
        end
    end
    cfg = [];
    cfg.appendsens = 'yes';
    Data = ft_appenddata(cfg, seegLaplace{:});% combine the data into one data structure
end