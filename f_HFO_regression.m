function Data = f_HFO_regression(Data, HFOs)
%
%
%
%%
    TrialCount = length(Data.trial);
    ChannelCount = length(Data.label);
    for ii_trial = 1:length(TrialCount)
        for ii_channel = 1:ChannelCount
            disp(['****Regress HFO noise of Trial :', num2str(ii_trial), ' - Channel ', num2str(ii_channel)]);
            signal = Data.trial{ii_trial}(ii_channel, :);
            HFOs_channel = HFOs{ii_trial}.Events{ii_channel};
            HFOCount = length(HFOs_channel.trial);
            for ii_event = 1:HFOCount
                sampleinfo = HFOs_channel.sampleinfo(ii_event, :);
                sampleList = sampleinfo(1):sampleinfo(2);
                if length(sampleList) > 2
                    y = signal(sampleList);
                    % Construct Regressors
                    HFOsignal = HFOs_channel.trial{ii_event};
                    HFOsignalEnvelope = abs(hilbert(HFOsignal));
                    %linear regression model
                    X = zeros(length(HFOsignal), 2);
                    X(:, 1) = HFOsignal;
                    X(:, 2) = HFOsignalEnvelope;
                    mdl = fitlm(X, y);
                    % New signal
                    Residuals = mdl.Residuals.Raw;
                    NewiEEGSignal = Residuals + mdl.Coefficients.Estimate(1);
                    signal(sampleList) = NewiEEGSignal;
                else
                    signal = f_interp1(signal, sampleList);
                end
            end
            Data.trial{ii_trial}(ii_channel, :) = signal;
        end
    end
end