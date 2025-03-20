function waveExtremaPointer = f_waveExtrema(signal)
    dfSignal = diff(signal);
    dfSignal(dfSignal>0) = 1; 
    dfSignal(dfSignal<0) = -1;
    ddfSignal = diff(dfSignal);
    waveExtremaIndex = find(abs(ddfSignal) > 0) + 1;
    waveExtremaPointer  =zeros(size(signal));
    waveExtremaPointer(waveExtremaIndex) = 1;
end