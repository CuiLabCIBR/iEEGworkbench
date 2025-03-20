function chanTable = f_channelTable_create(Data)
%
%
%% Channel Information 
    chanTable = table;
    chanTable.channel = Data.label;
    for ii_chan = 1:length(Data.label)
        chanTable.type{ii_chan} = {'SEEG'};
        chanTable.type{ii_chan} = categorical(chanTable.type{ii_chan}, {'SEEG', 'ECOG', 'EOG', 'EMG', 'Event', 'other'});
        chanTable.group(ii_chan) = join(regexp(Data.label{ii_chan}, '\D', 'match'), '');
        chanTable.goodORbad{ii_chan} = {'good'};
        chanTable.goodORbad{ii_chan} = categorical(chanTable.goodORbad{ii_chan}, {'good', 'bad'});
    end
end