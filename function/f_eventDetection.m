function [Event_begin, Event_end, PolyEvent] =  f_eventDetection(Pointer, TimeLThreshold, IntervalLThreshold)  
% f_eventDetection - Function to detect events in a binary signal based on time thresholds.  
%  
% Inputs:  
%   - Pointer: A binary signal where events are represented by 1s and non-events by 0s.  
%   - TimeThreshould: Minimum duration (in samples) for an event to be considered valid.  
%   - Interval: Maximum allowed gap (in samples) between two consecutive events to consider them as a single poly-event.  
%  
% Outputs:  
%   - Event_begin: Indices where events start in the input signal.  
%   - Event_end: Indices where events end in the input signal.  
%   - PolyEvent: A binary vector indicating the presence of poly-events (1) or not (0).  
%  
% Description:  
%   This function detects the start and end indices of events in a binary signal. It also identifies  
%   poly-events, which are defined as two or more consecutive events separated by a gap no longer than  
%   the specified Interval. Events shorter than the TimeThreshold are discarded.  
%
% Edited by Longzhou Xu, 2024-3-27
%% Main function  
    % Find the indices where events start (rising edge from 0 to 1)  
    Event_begin = find(diff([0, Pointer]) == 1);    
    % Find the indices where events end (falling edge from 1 to 0)  
    Event_end = find(diff([Pointer, 0]) == -1);  
    % Compute the length of each event  
    Event_length = Event_end - Event_begin;  
      
    % Discard events shorter than the TimeThreshold  
    Event_begin = Event_begin(Event_length >= TimeLThreshold);  
    Event_end = Event_end(Event_length >= TimeLThreshold);  
      
    % Compute the time interval between consecutive events  
    TimeInterval = Event_end(2:end) - Event_begin(1:end-1);  
    % Find the indices of events separated by a gap no longer than the Interval  
    Index = find(TimeInterval <= IntervalLThreshold);  
    % Expand the indices to include both events forming a poly-event  
    Index2 = unique([Index, Index+1]);  
    % Initialize a vector to store the poly-event indicators  
    PolyEvent = zeros(size(Event_begin));  
    % Mark the poly-events in the PolyEvent vector  
    PolyEvent(Index2) = 1;  
      
    % Remove the second event from a poly-event pair from the Event_begin and Event_end vectors  
    Event_begin(Index+1) = [];  
    Event_end(Index) = [];   
    % Remove the corresponding poly-event indicator
    PolyEvent(Index+1) = [];  
end