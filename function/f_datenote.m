function f_datenote()  
% f_datenote - This function displays the current date and time with a specific format,  
%                       surrounded by percentage signs as separators.  
%  
% The date and time are obtained using the 'now' function and formatted using  
% the 'datestr' function with the format 'yyyy-mm-dd HH:nn:ss' which represents  
% the year, month, day, hour, minute, and second respectively.  
%  
% The resulting string is then displayed using the 'disp' function, along with  
% the separators.  
%
% Edited by Longzhou Xu, 2024-3-27
%% main function  
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")  
    disp(datestr(now, 'yyyy-mm-dd HH:nn:ss')); % Display the current date and time  
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")  
end