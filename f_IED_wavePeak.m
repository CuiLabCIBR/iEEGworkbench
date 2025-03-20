function IEDpeak = f_IED_wavePeak(IEDsignal)
% f_IED_wavePeak - Detect peak position of IED events in input signal
% This function identifies transient peaks by analyzing velocity changes between signal extrema.
% Algorithm reference: [Add literature citation here, e.g., epilepsy detection papers]
%
% Input Parameters:
%   IEDsignal : 1D signal vector containing IED waveform data (e.g., EEG signal)
%
% Output Parameters:
%   IEDpeak   : Index of detected IED peak position in the input signal
%
% Implementation Steps:
%   1. Detect local extrema points
%   2. Calculate velocity changes between adjacent extrema
%   3. Locate maximum velocity interval and select candidate peaks
%   4. Choose peak with maximum amplitude from candidates
%
% Notes:
%   - Requires at least 3 extrema points for valid calculation
%   - Dependent on external function f_waveExtrema for extrema detection
% Edit by Longzhou Xu, 20250318
%%
    % Step 1: Detect local extrema points (peaks/valleys)
    waveExtremaPointer = f_waveExtrema(IEDsignal);
    % Get indices of all detected extrema
    waveExtremaIndex = find(waveExtremaPointer>0);

    % Step 2: Calculate amplitude differences and time intervals between extrema
    waveExtremaValue = IEDsignal(waveExtremaPointer==1); % Extract amplitude values at extrema points
    waveExtremaChange = diff(waveExtremaValue); % Amplitude differences
    waveExtremaTimeLength = diff(waveExtremaIndex); % Time intervals (in samples)
    % Compute velocity (absolute amplitude change per unit time)
    waveExtremaVelocity = abs(waveExtremaChange./waveExtremaTimeLength); 

    % Step 3: Identify candidate peak range (previous, current, next extrema)
    [~, b] = max(waveExtremaVelocity);
    b = [b-1, b, b+1];
    b(b<=0) = [];
    b(b>length(waveExtremaIndex)) = [];
    % Convert to original signal indices
    peakCandidate = waveExtremaIndex(b);

     % Step 4: Select peak with maximum absolute amplitude from candidates
    peakValue = IEDsignal(peakCandidate);
    [~, d] = max(abs(peakValue));  % Consider both positive/negative peaks
    IEDpeak = peakCandidate(d);
    % Validate peak position
    if IEDpeak < 1 || IEDpeak > numel(IEDsignal)
        error('Calculated peak position exceeds signal boundaries');
    end
end