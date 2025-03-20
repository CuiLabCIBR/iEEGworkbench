function [SignalWin, WinBegin, winEnd] = f_buffer(Signal, WinSize, WinStep)  
% f_buffer - Function to buffer (or window) a signal into overlapping or non-overlapping segments.  
%  
% Inputs:  
%   - Signal: The input signal to be windowed (vector).  
%   - WinSize: The size (length) of each window (scalar).  
%   - WinStep: The step size (in samples) between consecutive windows (scalar).  
%       If WinStep is smaller than WinSize, the windows will overlap.  
%       If WinStep is equal to WinSize, the windows will be adjacent (non-overlapping).  
%       If WinStep is larger than WinSize, there will be gaps between windows.  
%  
% Outputs:  
%   - Signal_Win: A matrix where each row represents a windowed segment of the input signal.  
%   - WinBegin: A vector containing the start indices of each window in the original signal.  
%   - winEnd: A vector containing the end indices of each window in the original signal.  
%  
% Note: This function uses parallel processing (parfor) to speed up the windowing process.  
% However, parallel processing may not always result in faster execution, especially for small datasets.  
% Consider using a regular for loop if parallel processing is not desired or does not provide a speedup.  
%  
%% Main function starts here  
    SignalLength = length(Signal);                                              % Get the length of the input signal  
    WinBegin = 1 : WinStep : SignalLength - WinSize+1;          % Calculate the start indices of the windows  
    if WinBegin(end)~=SignalLength-WinSize+1
        WinBegin = [WinBegin, SignalLength - WinSize + 1];      % Add the last window if needed (to ensure complete coverage)  
    end
    winEnd = WinBegin + WinSize-1;                                          % Calculate the end indices of the windows  

    SignalWin = zeros(length(WinBegin), WinSize);                                      % Preallocate memory for the windowed signal matrix  
    parfor ii_win = 1:length(WinBegin)                                                          % Use parallel processing to window the signal into segments 
        SignalWin(ii_win, :) = Signal(WinBegin(ii_win) : winEnd(ii_win));          % Extract the windowed segment from the signal  
    end  
end