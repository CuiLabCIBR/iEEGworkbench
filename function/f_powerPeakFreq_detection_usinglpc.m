function tfPowerSpectrum = f_powerPeakFreq_detection_usinglpc(data, freqRange, winSize, overlap, order)
% One fast algorithm to calculate the time-frequency power using lpc
% edited by Longzhou Xu
% Reference:
% 1. Janca, R., Jezdik, P., Cmejla, R., Tomasek, M., Worrell, G. A., Stead, M., . . . Marusic, P. (2015). 
%           Detection of interictal epileptiform discharges using signal envelope distribution 
%           modelling: application to epileptic and non-epileptic intracranial recordings. 
%           Brain Topogr, 28(1), 172-183. https://doi.org/10.1007/s10548-014-0379-1
%2. IED_detector_rev3.7.2014 https://isarg.fel.cvut.cz/downloads/
% 
%% main function
%=============== Initial setting==================================
    fsample = data.fsample;
    winSize = round(winSize*fsample);
    lowFreq = freqRange(1); 
    highFreq = freqRange(2);
    
%=============== low-pass filtering ===============================
    disp(['=====power-detection step 1: low pass filtering ====='])
    cfg = [];
    cfg.demean =  'yes';
    cfg.lpfilter = 'yes';
    cfg.lpfreq = highFreq+10;
    cfg.lpfiltord = 4;
    data = ft_preprocessing(cfg, data);

%=============== calculate the power spectrum =======================
    tfPowerSpectrum = data;
    for trialNum = 1:length(data.trial)
        trialSignals = data.trial{trialNum};
        trialPowerSpectrum = zeros(size(trialSignals));
        ifInterestFreqPeak = zeros(size(trialSignals));
        parfor channelNum = 1:size(trialSignals, 1)
            channelSignal = trialSignals(channelNum, :);

            %========slide window signals
            [segments, winBegin, winEnd] = f_series_segmentation(channelSignal, winSize, overlap);
            winIfInterestFreqPeak = zeros(1, length(winBegin));
            winPowerSpectrum = zeros(1, length(winBegin));

            %========calculate the power spectrum using lpc filter
            for winN = 1 : length(winBegin)
                    seg = segments(winN, :);
                    seg = zscore(seg);
                    A = lpc(seg, order); % calculate the powerspectrum using lpc
                    [h, freq] = freqz(1, A, [], fsample);
                    h = abs(h);
                    [~, locs] = findpeaks(h);% detect the peak of the power spectrum
                    winIfInterestFreqPeak(winN) = sum(freq(locs) <= highFreq & freq(locs) >= lowFreq)>0;
                    winPowerSpectrum(winN) = mean(h(freq <= highFreq & freq >= lowFreq));
            end

            %========interpolation to improve the time-solution
            x = [1, round((winBegin+winEnd)/2), length(channelSignal)];
            xq = 1 : length(channelSignal);
            v = [winIfInterestFreqPeak(1), winIfInterestFreqPeak, winIfInterestFreqPeak(end)];
            ifInterestFreqPeak(channelNum,  :) = interp1(x, v, xq, 'nearest');
            x = round((winBegin+winEnd)/2);
            trialPowerSpectrum(channelNum, :) = interp1(x, winPowerSpectrum, xq, 'spline');

        end
        %========output
        ifInterestFreqPeak = logical(ifInterestFreqPeak);
        tfPowerSpectrum.trial{trialNum} = trialPowerSpectrum;
        tfPowerSpectrum.ifInterestFreqPeak{trialNum} = ifInterestFreqPeak;
    end
    tfPowerSpectrum.interestFreqRange = freqRange;
    tfPowerSpectrum.lpcOrder = order;
end