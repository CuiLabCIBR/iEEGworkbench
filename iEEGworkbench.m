function iEEGworkbench
% iEEGPrep - Interactive Intracranial Electroencephalography (iEEG) Preprocessing Application
%
% This function launches a Graphical User Interface (GUI) application specifically designed for
% preprocessing and denoising iEEG data. Through an intuitive and guided workflow, 
% the application empowers users to effortlessly navigate through the preprocessing, 
% visualization, re-referencing, as well as the automated detection of
% Interictal Epileptic Discharges (IEDs) and High-Frequency Oscillations (HFOs) within the iEEG data.
%
% The GUI is meticulously crafted with a grid layout encompassing multiple panels. Each panel is
% meticulously tailored to handle a distinct step within the preprocessing pipeline, ensuring a
% seamless and structured user experience. Navigation between these steps is facilitated by
% conveniently placed buttons, with the current step prominently highlighted for clarity.
%
% As the user interacts with the buttons, each press triggers a meticulously designed callback
% function. These functions are responsible for seamlessly updating the application state and
% presenting the appropriate panel corresponding to the selected step, ensuring a smooth and
% intuitive workflow throughout the entire preprocessing process.
% 
% Edited by Longzhou Xu, 2024-07-04
    
%% Initialize GUI Panel
    ToolboxPath = iEEGworkbench_initial;
    % Create a UI figure and set its properties. 
    iEEGApp.UiFig = uifigure; 
    iEEGApp.UiFig.Name = 'iEEGworkbench v0.1.7';
    iEEGApp.ToolboxPath = ToolboxPath;
    screenSize = get(0, 'MonitorPositions'); 
    screenWidth = screenSize(1, 3);  
    screenHeight = screenSize(1, 4); 
    figWidth = 1000;  
    figHeight = 800;
    xPos = (screenWidth - figWidth) / 2;  
    yPos = (screenHeight - figHeight) / 2;  
    iEEGApp.UiFig.Position = [xPos yPos figWidth figHeight];
    % Create a grid layout and define its properties.  
    GridLayout = uigridlayout(iEEGApp.UiFig);
    GridLayout.RowHeight = {25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, '1x', 1};
    GridLayout.ColumnWidth = {200, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, '1x'};
    GridLayout.ColumnSpacing = 0;
    GridLayout.RowSpacing = 0;
    % Create the empty panels within the grid layout.
    f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], 1, 'workbench');
    f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [2, length(GridLayout.ColumnWidth)-2], 'Setting');
    f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [length(GridLayout.ColumnWidth)-1, length(GridLayout.ColumnWidth)], 'Input File List');
    iEEGApp.State = 'Start';
    % Create 8 buttons for setting pipeline
    Button = cell(6, 1);
    ButtonRow = {[2, 3], [4, 5], [6, 7], [8, 9], [10, 11], [12, 13]};
    ButtonColumn = 1;
    for ii_button = 1:6
        Button{ii_button} = uibutton(GridLayout, "state");
        Button{ii_button}.Layout.Row = ButtonRow{ii_button};
        Button{ii_button}.Layout.Column = ButtonColumn;
    end
%% Button 1 - Initiates minimal preprocessing of iEEG data  
    % Set the text of Button 1 to indicate its function.  
    Button{1}.Text = 'Step 1: iEEGPrep Pipeline'; 

    % Assign a callback function to the button.
    Button{1}.ValueChangedFcn = @(src, event) set_MiniPrep_panel(src, event);  
  
    % Callback Function for Button1  
    function set_MiniPrep_panel(~, ~) 
        
        if Button{1}.Value
            % Set the App state to 'MiniPrep'.  
            iEEGApp.State = 'iEEGPrep';

            % Deactivate all other buttons (set their Value to false). 
            Button = f_buttonDeactive(Button, 1);

            % Create empty clean panels for settings within the GridLayout.  
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [2, length(GridLayout.ColumnWidth)-2], 'Setting');  
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [length(GridLayout.ColumnWidth)-1, length(GridLayout.ColumnWidth)], 'Input File List');  
          
            % Call a function to set up the minimal preprocessing panel within the  
            % GridLayout and the preprocessing pipeline.  
            mb1_iEEGPrepPipeline_panel(iEEGApp, GridLayout);  
        else  
            % If Button1 is not pressed (Value is false), do nothing and exit the  
            % function.  
            return;  
        end  
    end

%% Button 2 - Initiates iEEG data visualization
    % Set the text of Button 2 to indicate its function.  
    Button{2}.Text = 'Step 2: Quality Control';  

    % A callback function is assigned to Button2.   
    Button{2}.ValueChangedFcn = @(src, event) set_iEEGVisualization_panel(src, event);
    
    % Definition of the callback function
    function set_iEEGVisualization_panel(~, ~)
        %
        if Button{2}.Value
            % Set the App state to 'iEEGViasualization'.  
            iEEGApp.State = 'QualityControl';

            % Deactivate all other buttons (set their Value to false). 
            Button = f_buttonDeactive(Button, 2);
            
            % Create empty clean panels for settings within the GridLayout.  
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [2, length(GridLayout.ColumnWidth)-2], 'Setting');
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [length(GridLayout.ColumnWidth)-1, length(GridLayout.ColumnWidth)], 'Input File List');

            % Call a function to set up the iEEG Visualization panel within the GridLayout.  
            mb2_QualityControl_panel(iEEGApp, GridLayout);
        else
            % If Button2 is not pressed, do nothing (simply return from the function).
            return;
        end
    end
%% Button 3 -  Initiates iEEG data Ref-reference.
    % Set the text of Button 3 to indicate its function.    
    Button{3}.Text = 'Step 3: iEEG Re-reference';
  
    % Assign a callback function to Button3.  
    % This function will be executed when the button's value changes (e.g., when it is pressed).  
    Button{3}.ValueChangedFcn = @(src, event) set_iEEGReference_pannel(src, event);  
  
    % Callback function for Button3.  
    function set_iEEGReference_pannel(~, ~)  
        % Check if Button3 is pressed (Value is true).  
        if Button{3}.Value  
            % Set the state of the iEEGPrep App to 'iEEGRereference'.  
            iEEGApp.State = 'iEEGRereference';  
          
            % Deactivate all other buttons (set their Value to false). 
            Button = f_buttonDeactive(Button, 3);
          
            % Create empty panels for settings related to the re-referencing process.  
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [2, length(GridLayout.ColumnWidth)-2], 'Setting');  
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [length(GridLayout.ColumnWidth)-1, length(GridLayout.ColumnWidth)], 'Input File List');  
          
            % Call the function that handles the specific re-referencing setup and display within the created panels.  
            mb3_iEEGReference_panel(iEEGApp, GridLayout);  
        else   
            % If Button3 is not pressed, do nothing and return from the function.  
            return;  
        end  
    end
%% Button 4 - Initiates IED auto-detection.
    % Set the text of Button 4 to indicate its function.  
    Button{4}.Text = 'IED Auto-detection';

    % Assign a callback function to Button 4.  
    Button{4}.ValueChangedFcn = @(src, event) set_IEDDetection_pannel(src, event);
    
    % Callback function for Button 4.  
    function set_IEDDetection_pannel(~, ~)
        % Check if Button 4 is in the pressed state (Value is true).
        if Button{4}.Value
            % Set the state of the iEEGPrep App to 'IEDDetection'.  
            iEEGApp.State = 'IEDDetection';

            % Deactivate all other buttons (set their Value to false). 
            Button = f_buttonDeactive(Button, 4);  

            % Create empty and clean panel for displaying the setting and input file list.
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [2, length(GridLayout.ColumnWidth)-2], 'Setting');
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [length(GridLayout.ColumnWidth)-1, length(GridLayout.ColumnWidth)], 'Input File List');
            
            % Call the function that handles the specific IED detection panel setup and display.
            mb4_IEDDetection_panel(iEEGApp, GridLayout);
        else
            % If Button 4 is not pressed, do nothing and return from the function.
            return;
        end
    end
%% Button 5 - Initiates HFO auto detection.
    % Set the text of Button 5 to indicate its function.  
    Button{5}.Text = 'HFO Auto-detection';
    
    % Asign a callback function for pressing the button 5.
    Button{5}.ValueChangedFcn = @(src, event) set_HFODetection_pannel(src, event);
    
    % Callback function for Button 5.
    function set_HFODetection_pannel(~, ~)
        % Check if Button 5 is in the pressed state (Value is true).  
        if Button{5}.Value
            % Set the state of the iEEGPrepApp to 'IEDDetection'.
            iEEGApp.State = 'HFODetection';

             % Deactivate all other buttons (set their Value to false). 
            Button = f_buttonDeactive(Button, 5); 

            % Create empty and clean panel for displaying the setting and input file list.
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [2, length(GridLayout.ColumnWidth)-2], 'Setting');
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [length(GridLayout.ColumnWidth)-1, length(GridLayout.ColumnWidth)], 'Input File List');
            
            % Call the function that handles the specific HFO detection panel setup and display.  
            mb5_HFODetection_panel(iEEGApp, GridLayout);
        else 
            % If Button 5 is not pressed, do nothing and return from the function.  
            return;  
        end
    end
%% Button 6 - Initiates HFO Visualization.
    % Set the text of Button 6 to indicate its function.  
    Button{6}.Text = 'iEEG Visualization';

    % Asign a callback function for pressing the button 6.
    Button{6}.ValueChangedFcn = @(src, event) set_HFOVisualization_pannel(src, event);
    
    % Define the callback function for Button 6. 
    function set_HFOVisualization_pannel(~, ~)
        % Check if Button 6 is pressed (Value is true).  
        if Button{6}.Value
            % Set the state of the iEEGPrepApp to 'HFOVisualization'.
            iEEGApp.State = 'HFOVisualization';

            % Deactivate all other buttons (set their Value to false). 
            Button = f_buttonDeactive(Button, 6); 
            
            % Create panels within the GridLayout to organize the interface.
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [2, length(GridLayout.ColumnWidth)-2], 'Setting');
            f_createPanel(GridLayout, [1 length(GridLayout.RowHeight)-1], [length(GridLayout.ColumnWidth)-1, length(GridLayout.ColumnWidth)], 'Input File List');
            
            % Call the mb6_HFOVisualization_panel function to set up the HFO Visualization panel. 
            mb6_HFOVisualization_panel(iEEGApp, GridLayout);
        else 
            % If Button 6 is not pressed (Value is false), do nothing and return.
            return;
        end
    end
end

%% subfunction to create a panel within a specified layout, at a given row and column, with a specified title  
function panel = f_createPanel(layout, row, col, title)  
    % create a new panel within the specified layout  
    panel = uipanel(layout);    
      
    % set the row position of the panel within the layout  
    panel.Layout.Row = row;  
      
    % set the column position of the panel within the layout  
    panel.Layout.Column = col;    
      
    % set the title of the panel  
    panel.Title = title;    
      
    % set the background color of the panel to white  
    panel.BackgroundColor = 'white';    
end  
  
%% subfunction to deactivate all buttons except for a specified one  
function Button = f_buttonDeactive(Button, N)  
    % set the specified button (indexed by N) to be active (or "pressed")  
    Button{N}.Value = true;  
      
    % create a list of button indices from 1 to 8  
    ButtonList = 1:8;  
      
    % remove the specified button index (N) from the list  
    ButtonList(ButtonList == N) = [];  
      
    % iterate over the remaining button indices in the list  
    for ii = 1:length(ButtonList)  
        % set each button in the list to be inactive (or "unpressed")  
        Button{ButtonList(ii)}.Value = false;  
    end  
end