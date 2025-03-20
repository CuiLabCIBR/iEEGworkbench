function SmoothedSignal = f_moveAverageFilter(Signal, WinSize) 
% f_moveAverageFilter - Function to apply a moving average filter to a signal  
%  
% Inputs:  
%   - Signal: The input signal to be smoothed.  
%   - WinSize: The size of the moving average window.  
%  
% Outputs:  
%   - SmoothedSignal: The input signal after applying the moving average filter.  
%  
% Description:  
%       This function computes the moving average of the input signal 'Signal'  
%       using a window size specified by 'WinSize'. The moving average filter  
%       coefficients are created by averaging ones over the window size. The  
%       function then applies this filter to the signal using the 'filtfilt'  
%       function, which performs zero-phase filtering by processing the data  
%       in both forward and reverse directions to eliminate phase distortion.  
%  
% Edited by Longzhou Xu, 2024-3-27
%% main function
    AverageFilter = ones(WinSize, 1) / WinSize;   
    SmoothedSignal = filtfilt(AverageFilter, 1, Signal);    
end
