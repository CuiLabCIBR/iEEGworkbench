function Data = f_filter_bandpass(Data, BandpassFreq)
%
%
%%
    % Perform Bandpass Filtering to Extract Signals of Interesting Frequency Band
    cfg = [];
    cfg.detrend = 'yes';
    cfg.demean = 'yes';
    cfg.baselinewindow = 'all';
    cfg.bpfilter = 'yes';
    cfg.bpfreq = BandpassFreq; 
    cfg.bpfiltord = 3; 
    Data = ft_preprocessing(cfg, Data);
%     %% v2 20241016
%     trialCount = length(Data.trial);
%     chanCount = length(Data.label);
%     for nTrial = 1:trialCount
%         for nChan = 1:chanCount
%             fsample = Data.fsample; % 采样频率
%             signal = Data.trial{nTrial}(nChan, :);
%             % 带通滤波器参数
%             low_cutoff = BandpassFreq(1); % 低截止频率
%             high_cutoff = BandpassFreq(2); % 高截止频率
%             order = 4; % 滤波器阶数
%             % 归一化截止频率
%             Wn = [low_cutoff high_cutoff] / (fsample / 2); 
%             % 设计Butterworth带通滤波器
%             [b, a] = butter(order, Wn, 'bandpass');
%             % 应用滤波器
%             filtered_signal = filter(b, a, signal);
%             Data.trial{nTrial}(nChan, :) = filtered_signal;
%         end
%     end
end