function signal = f_interp1(signal, aimXindex)

%%
    newAimXindex1 = [aimXindex-1, aimXindex, aimXindex+1];
    newAimXindex1 = unique(newAimXindex1);
    newAimXindex1(newAimXindex1<=0) = [];
    newAimXindex1(newAimXindex1>length(signal)) = [];
    newAinXindex2 = newAimXindex1;
    newAinXindex2(newAinXindex2 == aimXindex(1)) = [];
    newAinXindex2(newAinXindex2 == aimXindex(end)) = [];
    NewiEEGSignal = interp1(newAinXindex2, signal(newAinXindex2), newAimXindex1, 'spline');
    signal(newAimXindex1) = NewiEEGSignal;
end