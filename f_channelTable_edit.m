function chanTable = f_channelTable_edit(chanTable, aimChan, varName, variables)
%
%%
    % edit the channel table
    for ii_chan = 1:length(chanTable.channel)
        if strcmp(chanTable.channel{ii_chan}, aimChan)
            chanTable.(varName){ii_chan} = {variables};
            chanTable.type{ii_chan} = categorical(chanTable.type{ii_chan}, {'SEEG', 'ECOG', 'EOG', 'EMG', 'Event', 'other'});
            chanTable.goodORbad{ii_chan} = categorical(chanTable.goodORbad{ii_chan}, {'good', 'bad'});
        end
    end
end