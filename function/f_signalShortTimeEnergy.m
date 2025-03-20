function ShortTimeEnergy = f_signalShortTimeEnergy(Signal, WinSize)
% f_signalShortTimeEnergy - Function to compute the short-time energy of a signal.  
%  
% Inputs:  
%   - Signal: The input signal for which the short-time energy is to be computed.  
%   - WinSize: The size of the sliding window used to compute the short-time energy.  
%  
% Outputs:  
%   - ShortTimeEnergy: A vector containing the short-time energy values of the signal.  
%
% Description: 
%       This function computes the element-wise square of the signal (energy) and then 
%       applies a moving average with the specified window size. However, the moving 
%       average is not centered in the edge of the signal.
%
% Edited by Longzhou Xu, 2024-3-27
%% main function
    SiganlEnergy = Signal.^2;
    ShortTimeEnergy = movmean(SiganlEnergy, WinSize);
end
