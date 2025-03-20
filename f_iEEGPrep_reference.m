function Data = f_iEEGPrep_reference(Data, Method, ChannelTable)
%
%
%
%%
    chanLabels = Data.label;
    seegChanNum = 0;
    for nChan1 = 1:size(ChannelTable, 1)
        if ChannelTable.goodORbad{nChan1} == 'good' && ChannelTable.type{nChan1} == 'SEEG'
            for nChan2 = 1:length(chanLabels)
                if strcmp(ChannelTable.channel{nChan1}, chanLabels{nChan2})
                    seegChanNum = seegChanNum + 1;
                    seegChanLabels{seegChanNum} = ChannelTable.channel{nChan1};
                    seegChanGroups{seegChanNum} = ChannelTable.group{nChan1};
                end
            end
        end
    end
    ecogChanNum = 0;
    for nChan1 = 1:size(ChannelTable, 1)
        if ChannelTable.goodORbad{nChan1} == 'good' && ChannelTable.type{nChan1} == 'ECOG'
            for nChan2 = 1:length(chanLabels)
                ecogChanNum = ecogChanNum + 1;
                ecogChanLabels{ecogChanNum} = ChannelTable.channel{nChan1};
                ecogChanGroups{ecogChanNum} = ChannelTable.group{nChan1};
            end
        end
    end
    cfg = [];
    cfg.channel = seegChanLabels;
    seegData = ft_preprocessing(cfg, Data);
    seegData =  f_reref_SEEG(seegData, Method, seegChanGroups);
    Data = SEEGData;
end