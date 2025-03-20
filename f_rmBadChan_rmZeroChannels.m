function [Data, chanTable] = f_rmBadChan_rmZeroChannels(Data, chanTable)
%
%
%%
    % Find zero channels
    zeroChans = f_rmBadChan_findZeroChannels(Data);
    
    % edit channel table
    for ii_zeroChan = 1:length(zeroChans)
        chanTable = f_channelTable_edit(chanTable, zeroChans{ii_zeroChan}, 'goodORbad', 'bad');
    end

    % delete zeros channels
    ZeroChanGroup = [];
    for CL = 1:length(zeroChans)
          ZeroChanGroup{CL} = ['-', zeroChans{CL}];
    end
    ZeroChanGroup = [{'all'}, ZeroChanGroup];
    cfg = [];
    cfg.channel = ZeroChanGroup;
    Data = ft_preprocessing(cfg, Data);
end
