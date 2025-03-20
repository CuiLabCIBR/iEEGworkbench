function newData = f_redefineTrial_resting(Data, NewTrialTimeLength, NewTimeSeriesYeoOrNo)
%
%
    fsample = Data.fsample;
    NewTrialLength = ceil(NewTrialTimeLength*fsample);
    N = 0;
    for nTrial = 1:length(Data.trial)
        time = Data.time{nTrial};
        trial = Data.trial{nTrial};
        winBegin = 1:NewTrialLength:size(trial, 2);
        winEnd = winBegin + NewTrialLength - 1;
        winBegin(winEnd>size(trial, 2)) = [];
        winEnd(winEnd>size(trial, 2)) = [];
        for nNT = 1:length(winBegin)
            N = N + 1;
            newTrial{N} = trial(:, winBegin(nNT):winEnd(nNT));
            newTime{N} = time(winBegin(nNT):winEnd(nNT));
            if strcmp(NewTimeSeriesYeoOrNo, 'yes')
                newTime{N} = (1/fsample:1/fsample:(size(newTrial{N}, 2)/fsample))-1/fsample;
            end
            newSampleinfo(N, :) = [winBegin(nNT), winEnd(nNT)];
        end
    end
    if exist("newTrial", "var")
        newData = Data;
        newData.trial = newTrial;
        newData.time = newTime;
        newData.sampleinfo = newSampleinfo;
    else 
        newData = [];
    end
end