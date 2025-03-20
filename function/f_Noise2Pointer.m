function noisePointer = f_Noise2Pointer(noise)
%
%
%
%
    trialTotal = length(noise);
    noisePointer = cell(1, trialTotal);
    for ii_trial = 1:trialTotal
        fieldNames = fieldnames(noise{ii_trial});
        if sum(strcmp(fieldNames, 'IEDs')) == 1
            noiseName = 'IEDs';
        end
        if sum(strcmp(fieldNames, 'HFOs')) == 1
            noiseName = 'HFOs';
        end
        channelTotal = length(noise{ii_trial}.(noiseName));
        sampleinfo = noise{ii_trial}.sampleinfo;
        signalLength = sampleinfo(ii_trial, 2) - sampleinfo(ii_trial, 1) + 1;
        pointer = zeros(channelTotal, signalLength);
        for ii_channel = 1:length(channelTotal)
            sampleinfo = noise{ii_trial}.(noiseName){ii_channel}.sampleinfo;
            noiseTotal = size(sampleinfo, 1);
            for ii_IED = 1:noiseTotal
                pointer(ii_channel, sampleinfo(ii_IED, 1):sampleinfo(ii_IED, 2)) = 1;
            end
        end
        pointerSum = sum(pointer, 1);
        pointerSum(pointerSum>=1) = 1;
        [noise_begin, noise_end] = f_eventDetection(pointerSum, 0, 0);
        noise_channel = zeros(channelTotal, length(noise_begin));
        for ii_noise = 1:length(noise_begin)
            pointer_event = pointer(:, noise_begin(ii_noise):noise_end);
            pointer_event = sum(pointer_event, 2);
            noise_channel(:, ii_noise) = pointer_event>=1;
        end
    end
end