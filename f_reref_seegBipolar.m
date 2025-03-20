function Data = f_reref_seegBipolar(Data, chanGroups)
%
%
%%
     chanLabels = Data.label;
    [groupLabels, ~, ia] = unique(chanGroups);
    NN = 0;
    for nGroup = 1:length(groupLabels)
        groupChans = chanLabels(ia == nGroup);
        chanNum = zeros(size(groupChans));
        for nChan = 1:length(groupChans)
            chanNumStr = f_strsplit(groupChans{nChan}, groupLabels{nGroup});
            chanNum(nChan) = str2num(chanNumStr{1});
        end
        Index1 = find(diff(chanNum)>1);
        if isempty(Index1)
            NN = NN + 1;
            cfg = []; 
            cfg.channel = groupChans;
            cfg.reref = 'yes';
            cfg.refchannel = 'all';
            cfg.updatesens = 'yes';
            cfg.refmethod = 'bipolar';
            seegBipolar{NN} = ft_preprocessing(cfg, Data);
        else
            Index2 = [0, Index1(:)', length(groupChans)];
            for nIndex = 1:length(Index2)-1
                NN = NN + 1;
                cfg = [];
                cfg.channel = groupChans(Index2(nIndex)+1:Index2(nIndex+1));
                cfg.reref = 'yes';
                cfg.refchannel = 'all';
                cfg.updatesens = 'yes';
                cfg.refmethod = 'bipolar';
                seegBipolar{NN} = ft_preprocessing(cfg, Data);
            end
        end
    end
    cfg = [];
    cfg.appendsens = 'yes';
    Data = ft_appenddata(cfg, seegBipolar{:});% combine the data into one data structure
    for nChanA = 1:length(Data.label)
        TempSTR = f_strsplit(Data.label{nChanA}, '-');
        Data.label{nChanA} = TempSTR{1};
    end
end