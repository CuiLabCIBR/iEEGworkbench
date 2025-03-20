function RunButton = ui_createRunButton(IEEGApp, GridLayout, Row, Column)  
% ui_createRunButton - Creates a 'Run' button with an icon and assigns it to a specific row and column in the GridLayout.  
%  
% INPUT  
%   IEEGPrepApp: A structure containing information about the IEEG preparation application, including the ToolboxPath.  
%   GridLayout: The uigridlayout object to which the button will be added.  
%   Row: The row index within the GridLayout where the button should be placed.  
%   Column: The column index within the GridLayout where the button should be placed.  
%  
% OUTPUT  
%   RunButton: The created uibutton object.  
%  
% Description  
%   This function creates a uibutton control with the label 'Run' and assigns it to a specific row and column  
%   within the provided GridLayout. It also sets an icon for the button using the full path to the icon file,  
%   which is retrieved from the IEEGPrepApp structure. The icon is aligned to the top of the button.
%
%% Main function 
    % Create a uibutton control and assign it to the variable RunButton.  
    % The 'state' property of the GridLayout is used to initialize the button.  
    RunButton = uibutton(GridLayout, 'state');  
      
    % Set the layout position of the button within the GridLayout.  
    % The Row and Column parameters determine the button's position.  
    RunButton.Layout.Row = Row;  
    RunButton.Layout.Column = Column;  
      
    % Set the text displayed on the button to 'Run'.  
    RunButton.Text = 'Run';  
      
    % Assign an icon to the button using the full path to the icon file.  
    RunButton.Icon = fullfile(IEEGApp.ToolboxPath, 'data', 'run.png');  
      
    % Set the alignment of the icon to the top of the button.  
    RunButton.IconAlignment = "top";  
end

