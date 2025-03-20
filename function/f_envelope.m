function Data = f_envelope(Data)
% Function to perform bandpass filtering and envelope detection on input data.  
%  
% Inputs:  
%   - Data: A structure containing the signal data to be processed. 
%  
% Outputs:  
%   - Data: The input Data structure is modified to include the envelope of the signal.  
%           Specifically, the 'trial' field of Data will be replaced by the envelope of the filtered signal.  
%  
% Notes:  
%   - The envelope is calculated using the Hilbert transform, which is a common method for envelope detection.  
%  
% Edited by Longzhou Xu, 2024-4-18
    %Calculate Envelope Using Hilbert Transform
    TrialCount = length(Data.trial);
    for ii_trial = 1:TrialCount
        Data.trial{ii_trial} =  abs(hilbert(Data.trial{ii_trial}'))';% hilbert envelop
    end
end