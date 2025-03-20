function chanTable = f_channelTable_gui(chanTable)
%
%
%%
    chanTableFig = uifigure;
    chanTableFig.Tag = 'ChannelTable';
    ChannelTableFigGL = uigridlayout(chanTableFig, [1, 1]);
    chanUitable = uitable(ChannelTableFigGL, "Data", chanTable);
    chanUitable.ColumnEditable = [false true true true];
    chanUitable.CellEditCallback = @(src, event) editChanGUI(src, event);
    chanTableFig.CloseRequestFcn = @(src, event) closeChanGUI(src, event);
    waitfor(chanTableFig);

%% callback function
    function editChanGUI(~, event)
        EditedRow = event.Indices(1); 
        EditedColumn = event.Indices(2); 
        NewData = event.NewData;
        chanTable{EditedRow, EditedColumn} = {NewData};
    end

    function closeChanGUI(~, ~)
        confirmMSG = 'Close the table window?';
        confirmTitle = 'Confirm Close';
        selection = uiconfirm(chanTableFig, confirmMSG, confirmTitle, ...
            "Options", {'OK', 'Cancel'});
        switch selection
            case 'OK'
                delete(chanTableFig);
            case 'Cancel'
                return;
        end
    end
end
