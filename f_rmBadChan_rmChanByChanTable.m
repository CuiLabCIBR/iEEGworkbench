function Data = f_rmBadChan_rmChanByChanTable(Data, ChannelTable)
%
%
%%
    % find the bad channels 
    BadChannel = [];
    N = 0;
    for ii_chan = 1:length(ChannelTable.channel)
        ChannelLabel = char(ChannelTable.goodORbad{ii_chan});
        if strcmp(ChannelLabel,  'bad')
              N = N+1;
              BadChannel{N} = ChannelTable.channel{ii_chan};
        end
    end
    BadChannel = unique(BadChannel);

    % compare the bad channels and channels in Data 
    Channel = Data.label;
    NN = 0;
    BadChannelGroup = [];
    for ii_chan = 1:length(Channel)
        for ii_badchan = 1:length(BadChannel)
            if contains(Channel{ii_chan}, BadChannel{ii_badchan})
                STR = f_strsplit(Channel{ii_chan}, '-');
                for ii_STR = 1:length(STR)
                    if strcmp(STR{ii_STR}, BadChannel{ii_badchan})
                        NN = NN + 1;
                        BadChannelGroup{NN} = ['-', Channel{ii_chan}];
                    end
                end
                if strcmp(Channel{ii_chan}, BadChannel{ii_badchan})
                    NN = NN + 1;
                    BadChannelGroup{NN} = ['-', Channel{ii_chan}];
                end
            end
        end
    end
    BadChannelGroup = unique(BadChannelGroup);
    BadChannelGroup = [{'all'}, BadChannelGroup];

    % remove bad channels
    cfg = [];
    cfg.channel = BadChannelGroup;
    Data = ft_preprocessing(cfg, Data);
end