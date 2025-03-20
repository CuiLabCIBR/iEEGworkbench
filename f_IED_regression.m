function Data = f_IED_regression(Data, IEDs)
%
%
%
%%
    TrialCount = length(Data.trial);
    ChannelCount = length(Data.label);
    for ii_trial = 1:length(TrialCount)
        for ii_channel = 1:ChannelCount
            disp(['****Regress IED noise of Trial :', num2str(ii_trial), ' - Channel ', num2str(ii_channel)]);
            signal = Data.trial{ii_trial}(ii_channel, :);
            IEDs_channel = IEDs{ii_trial}.Events{ii_channel};
            IEDCount = length(IEDs_channel.trial);
            for ii_event = 1:IEDCount
                sampleinfo = IEDs_channel.sampleinfo(ii_event, :);
                sampleList = sampleinfo(1):sampleinfo(2);
                if length(sampleList) > 2
                    y = signal(sampleList);
                    % Construct Regressors
                    IEDsignal = IEDs_channel.trial{ii_event};
                    % linear regression model
                    mdl = fitlm(IEDsignal, y);
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