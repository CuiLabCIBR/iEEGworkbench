function [Data, shortTEnergySta]= f_HFO_shortTEnergy(Data, WinSize)
%
%
%
%% Calculate short-time energy of the signal
    trialCount = length(Data.trial);
    sTEnergy_allTrial = [];

    % calculate short-time energy  
    for ii_trial = 1:trialCount  
        IEEG_trial = Data.trial{ii_trial};
        IEEG_trial = IEEG_trial.^2;
        sTEnergy_trial = movmean(IEEG_trial, WinSize, 2);
        Data.trial{ii_trial} = sTEnergy_trial; 
        sTEnergy_allTrial = [sTEnergy_allTrial, sTEnergy_trial];
    end

    % calculate statical infomation of short-time energy
    steMean = mean(sTEnergy_allTrial(:));
    steStd = std(sTEnergy_allTrial(:));
    sTEnergy_allTrial(sTEnergy_allTrial>steMean+10*steStd) = steMean+10*steStd;
    steEdges = linspace(min(min(sTEnergy_allTrial)), max(max(sTEnergy_allTrial)), 100);
    for nChan = 1:size(sTEnergy_allTrial)
        [PDF(nChan, :), ~] = histcounts(sTEnergy_allTrial(nChan, :), steEdges);
    end
    PDF = log10(PDF./size(sTEnergy_allTrial, 2));
    shortTEnergySta.mean = mean(sTEnergy_allTrial, 2); 
    shortTEnergySta.std = std(sTEnergy_allTrial, 0, 2);
    shortTEnergySta.PDF = PDF;
    shortTEnergySta.PDFedges = steEdges;
end