function Segment = f_strsplit(CharSeries, Pattern)  
% f_strsplit Splits a character series (string) into segments based on a given pattern.  
%  
% INPUT:  
%   CharSeries - The input character series (string) to be split.  
%   Pattern - The pattern based on which the splitting will occur.  
%  
% OUTPUT:  
%   Segment - A cell array containing the resulting segments after splitting CharSeries based on Pattern.  
%  
% DESCRIPTION:  
%   This function takes a character series (CharSeries) and splits it into multiple segments   
%   based on a specified pattern (Pattern). The resulting segments are stored in a cell array   
%   called Segment.  
%  
% ALGORITHM:  
%   1. Check if CharSeries is not a character array. If not, convert it to a character array.  
%   2. Initialize a Pointer array of the same size as CharSeries with all elements set to 1.  
%      This array will be used to mark the positions of characters that are part of the Pattern.  
%   3. Find the starting positions of all occurrences of the Pattern in CharSeries using strfind.  
%   4. Calculate the ending positions of all occurrences of the Pattern by adding the length of   
%      the Pattern minus 1 to each starting position.  
%   5. Loop through all the found occurrences of the Pattern and set the corresponding positions   
%      in the Pointer array to 0.  
%   6. Find the starting positions of the segments by looking for where the Pointer array changes   
%      from 0 to 1. This is done by taking the difference between adjacent elements in the   
%      [0, Pointer] array and finding where it equals 1.  
%   7. Find the ending positions of the segments by looking for where the Pointer array changes   
%      from 1 to 0. This is done by taking the difference between adjacent elements in the   
%      [Pointer, 0] array and finding where it equals -1.  
%   8. Loop through all the found segments and extract each segment from CharSeries using the   
%      starting and ending positions. Store each segment in the Segment cell array.  
%
%
% Edited by Longzhou Xu, 2024-3-27  
%% Main function  
    % Check if CharSeries is not a character array. If not, convert it to a character array.  
    if ~ischar(CharSeries)  
        CharSeries = char(CharSeries);  
    end  
  
    % Initialize a Pointer array of the same size as CharSeries with all elements set to 1.  
    % This Pointer array will be used to mark the positions of the characters that are part of the Pattern.  
    Pointer = ones(size(CharSeries));  
      
    % Find the starting positions of all occurrences of the Pattern in CharSeries.  
    k_begin = strfind(CharSeries, Pattern);  
      
    % Calculate the ending positions of all occurrences of the Pattern.  
    % This is done by adding the length of the Pattern minus 1 to each starting position.  
    k_end = k_begin + length(Pattern)-1;  
      
    % Loop through all the found occurrences of the Pattern.  
    for ii = 1:length(k_begin)  
        % Set the corresponding positions in the Pointer array to 0, indicating that these characters are part of the Pattern.  
        Pointer(k_begin(ii):k_end(ii)) = 0;  
    end  
  
    % Find the starting positions of the segments by looking for where the Pointer array changes from 0 to 1.  
    % This is done by taking the difference between adjacent elements in the [0, Pointer] array and finding where it equals 1.  
    SegmentBegin = find(diff([0, Pointer]) == 1);  
      
    % Find the ending positions of the segments by looking for where the Pointer array changes from 1 to 0.  
    % This is done by taking the difference between adjacent elements in the [Pointer, 0] array and finding where it equals -1.  
    SegmentEnd = find(diff([Pointer, 0]) == -1);  
      
    % Loop through all the found segments.  
    for ii_seg = 1:length(SegmentBegin)  
        % Extract the segment from CharSeries using the starting and ending positions, and store it in the Segament cell array.  
        Segment{ii_seg} = CharSeries(SegmentBegin(ii_seg):SegmentEnd(ii_seg));  
    end  
end