function IEDsampleinfo = f_IED_sampleinfo(iEEGEnvelope, winSize, IEDThreshold)  
% Inputs:  
%   - Data: Structure containing signal Envelope.  
%   - WinSize: Window size in seconds for moving average and standard deviation calculations.  
%   - IEDThreshold: Multiplier for the threshold curve calculation.  
%  
%  
% Edited by Longzhou Xu, 2024-10-12 
    fsample = iEEGEnvelope.fsample;                         % Sampling frequency  
    winSize = ceil(winSize * fsample);          % Convert window size to samples  
    trialCount = length(iEEGEnvelope.trial);                % Number of trials
    chanCount = length(iEEGEnvelope.label); % Number of channels
    IEDsampleinfo = cell(chanCount, trialCount);
    for nTrial = 1:trialCount  
        Envelope_trial = iEEGEnvelope.trial{nTrial}; % Envelope data for the current trial  
        % Calculate moving average and standard deviation
        Mu = movmean(log(Envelope_trial), winSize, 2);
        Mu = movmean(Mu, winSize, 2);
        Sigma = movstd(log(Envelope_trial), winSize, 0, 2);
        Sigma = movmean(Sigma, winSize, 2);
        Mode = exp(Mu-Sigma.^2);
        Median = exp(Mu);
        % Calculate threshold curve based on log-normal distribution parameters 
        ThresholdCurve_trial = IEDThreshold*(Mode+Median);
        % find the IED event
        IEDpointer = Envelope_trial>=ThresholdCurve_trial;
        for nChan = 1:chanCount
            pointerChan = IEDpointer(nChan, :);
            [IEDbegin, IEDend, ~] =  f_eventDetection(pointerChan, 0, 0);
            IEDsampleinfo{nChan, nTrial} = [IEDbegin(:), IEDend(:)];
        end
    end  
end