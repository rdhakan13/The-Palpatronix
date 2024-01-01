function save_file_prompt(tumour_data,potential_tumour_data,file_name,y_array,x_array,binary_array,graph)
% save_file_prompt.m creates a prompt of listbox allowing the user to select different methods of saving files 

% creates figure
set(0,'units','pixels')  
%Obtains this pixel information
h.f = figure('units','pixels','position',[500,500,400,50],...
             'toolbar','none','menu','none','Name',...
             'Please choose a method to save your file: ',...
             'NumberTitle','off');
% create checkboxes to select method of saving
h.c(1) = uicontrol('style','checkbox','units','pixels',...
                'position',[90,30,50,15],'string','Table'); % for table
h.c(2) = uicontrol('style','checkbox','units','pixels',...
                'position',[190,30,50,15],'string','Graph');% for graph
h.c(3) = uicontrol('style','checkbox','units','pixels',...
    'position',[290,30,50,15],'string','Binary'); % for binary
% creates OK pushbutton   
h.p = uicontrol('style','pushbutton','units','pixels',...
                'position',[170,5,70,20],'string','OK',...
                'callback',@p_call);
    % Pushbutton callback
    function p_call(varargin)
        values = get(h.c,'Value'); % gets a cell array of the check boxes
        done = get(h.p,'Value'); % checks if OK is pressed
        values = cell2mat(values); % converts the cell array to a matrix
        if done == 1
            % if OK is pressed then the figure is closed
            close(h.f)
        end
        check = find(values); % creates an array of linear indexes where
        % a box is checked
        check = mat2str(check); % convert the matrix to a string for 
        % comparison
        switch check % switch case to identify the correct ways to save 
        % file
            case '1'
                save_as_table(tumour_data,potential_tumour_data,file_name)
                % saves as table only
            case '2'
                save_as_graph(file_name,graph)
                % saves as graph only
            case '3'
                save_as_binary(y_array,x_array,binary_array,file_name)
                % saves as binary only
            case '[1;2]'
                save_as_table(tumour_data,potential_tumour_data,file_name)
                save_as_graph(file_name,graph)
                % saves as table and graph
            case '[2;3]'
                save_as_graph(file_name,graph)
                save_as_binary(y_array,x_array,binary_array,file_name)
                % saves as binary and graph
            case '[1;3]'
                save_as_table(tumour_data,potential_tumour_data,file_name)
                save_as_binary(y_array,x_array,binary_array,file_name)
                % saves as table and binary
            case '[1;2;3]'
                save_as_table(tumour_data,potential_tumour_data,file_name)
                save_as_graph(file_name,graph)
                save_as_binary(y_array,x_array,binary_array,file_name)
                % saves all
        end 
    end

end