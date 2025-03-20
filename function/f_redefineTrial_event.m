function newData = f_redefineTrial_event(Data, TRIG, TRIGtime, trialLength, trial_0time)
%
%
%% find trial begin
    TRIGAB = [];
    TRIGtimeAB = [];
    for nBlock = 1:length(TRIG)
        TRIGAB = [TRIGAB, TRIG{nBlock}];
        TRIGtimeAB = [TRIGtimeAB, TRIGtime{nBlock}];
    end
    eventValue = unique(TRIGAB);
    TRIGAB(TRIGAB<max(eventValue)) = 0; 
    TRIGAB(TRIGAB> 0 ) = 1;
    [EventBegin, ~, ~] = f_eventDetection(TRIGAB, 0, 0);
    EventBeginT= TRIGtimeAB(EventBegin);
    
%% redefine trial
    trialAB = [];
    timeAB = [];
    for nBlock = 1:length(Data.trial)
        trialAB = [trialAB, Data.trial{nBlock}];
        timeAB = [timeAB, Data.time{nBlock}];
    end
    fsample = Data.fsample;
    trialLength = ceil(trialLength*fsample);
    trial_0time = ceil(trial_0time*fsample);
    for nTrial = 1:length(EventBeginT)
        [~, Index] = min(abs(timeAB-EventBeginT(nTrial)));
        time_onetrial = timeAB(Index:Index+trialLength-1);
        time{nTrial} =  time_onetrial - time_onetrial(trial_0time);
        simpleinfo(nTrial, :) = [Index, Index+trialLength-1];
        trial{nTrial} = trialAB(:, Index:Index+trialLength-1);
    end
    newData.cfg = Data.cfg;
    newData.fsample = fsample;
    newData.label = Data.label;
    newData.time = time;
    newData.sampleinfo = simpleinfo;
    newData.trial = trial;
end