function save_as_graph(file_name,graph)
% save_as_graph.m saves the graphs as JPEG format

file_name = strcat(file_name(1:(end-4)),'_result_graph.jpeg'); % sets a 
% default filename based on the filename of the data inputted in
% the code
[file,path] = uiputfile(file_name,'Please save your file');% opens a 
% dialog box allowing the user to name the file or to keep the default name 
% and save it in their chosen location
if file==0 % if the dialog box is canceled the program returns
    return
end 
filename = fullfile(path,file);% this code allows to save the file 
% outside of the defualt directory
export_fig(graph, filename, '-jpg'); % export_fig is a user defined function
% which was downloaded from https://uk.mathworks.com/matlabcentral/fileexchange/23629-export_fig
% and is created by Yair Altman. This function allows the user to save just
% the graph from the GUI
% Full Reference - 
% Title: export_fig
% Author: Altman.Y
% Date: 2018
% Code Version: 2.0.0.0
% Availablity: https://uk.mathworks.com/matlabcentral/fileexchange/23629-export_fig 
% The following user-defined function are part of 'export_fig.m' :
% append_pdfs, copyfig, crop_borders, eps2pdf, fix_lines, ghostscript,
% im2gif, isolate_axes, pdf2eps, pdftops, print2array, print2eps,
% read_write_entire_textfile, user_string, using_hg2

end 