function newEventSampleinfo = f_wholeWave(signal, eventSampleinfo)
%
%
%
%% Obtain the Whole Wave of Event
    EventBegin =  eventSampleinfo(:, 1);
    EventEnd = eventSampleinfo(:, 2);
    waveExtremaPointer = f_waveExtrema(signal);
    waveExtremaIndex = find(waveExtremaPointer>0);
    waveLength = ceil(4*max(diff(waveExtremaIndex)));
    EventCount = length(EventBegin);
    pointer = zeros(size(signal));
    for nEvent = 1:EventCount
        oldBegin = EventBegin(nEvent);
        oldEnd = EventEnd(nEvent);
        waveExtremaPointer_old = waveExtremaPointer(oldBegin:oldEnd);
        pointer(oldBegin:oldEnd)=1;

        % select time window of interest to reduce computation cost
        sampleList = oldBegin-waveLength:oldEnd+waveLength;
        sampleList(sampleList<=0) = [];
        sampleList(sampleList>length(signal)) = [];
        waveExtremaPointer_soi = waveExtremaPointer(sampleList);
        waveExtremaIndex_soi = find(waveExtremaPointer_soi)+sampleList(1)-1;

        % calculate the cut between wave extrema and old begin
        CBegin = waveExtremaIndex_soi - oldBegin;
        CBegin(CBegin>0)=min(CBegin);
        [~, CUTBegin] = max(CBegin);
        % calculate the cut between wave extrema and old end
        CEnd = waveExtremaIndex_soi - oldEnd;
        CEnd(CEnd<0)=max(CEnd);
        [~, CUTEnd] = min(CEnd);
        % expand two or three step of wave extrema
        if sum(waveExtremaPointer_old)==0
            CUTBegin = CUTBegin - 4;
            CUTBegin(CUTBegin<1) = 1;
            CUTEnd = CUTEnd + 4;
            CUTEnd(CUTEnd>length(waveExtremaIndex_soi)) = length(waveExtremaIndex_soi);
        else
            CUTBegin = CUTBegin - 3;
            CUTBegin(CUTBegin<1) = 1;
            CUTEnd = CUTEnd + 3; 
            CUTEnd(CUTEnd>length(waveExtremaIndex_soi)) = length(waveExtremaIndex_soi);
        end

        % find new begin and new End of event to complete the wave of event
        newBegin = waveExtremaIndex_soi(CUTBegin);
        pointer(newBegin:oldBegin) = 1;
        % New End of the Event
        newEnd = waveExtremaIndex_soi(CUTEnd);
        pointer(oldEnd:newEnd) = 1;
    end
    % New Event End and Event Begin
    [NewEventBegin, NewEventEnd] = f_eventDetection(pointer, 0, 0);
    newEventSampleinfo(:, 1) = NewEventBegin;
    newEventSampleinfo(:, 2) = NewEventEnd;
end