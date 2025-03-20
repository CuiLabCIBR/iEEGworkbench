function Data = f_reref_SEEG(Data, Method, chanGroups)
%
%
% 
%% perform rereference
    switch Method
        case 'CommonAverage'
            Data = f_reref_commonAvg(Data);
        case 'ChannelAverage'
            Data = f_reref_channelAvg(Data, chanGroups);
        case 'Bipolar'
            Data = f_reref_seegBipolar(Data, chanGroups);
        case 'Laplace'
            Data = f_reref_seegLaplace(Data, chanGroups);
    end
end

