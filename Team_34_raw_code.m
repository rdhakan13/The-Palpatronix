% team_34.m (Code completed in R2018b) Muhab Hasan (mn18mh), Raj Dhakan (mn18rad), Shion Lahiri (mn18sl)

%% clearing workspace and command window
clear;
clc;

%% reading file

file_name = uigetfile('*.csv','Please select a CSV file'); % opens a window
% from which user selects a file

% readingfile is a user-defined function which reads the file and checks
% whether it is of the correct type and in correct format
[x_resolution,y_resolution,depth,force_data] = readingfile(file_name);

%% going through the entire force_data to convert to stiffness values

force_dim = size(force_data); % calculates the dimensions of the matrix 
% which holds the force data
stiffness_data = force_data/depth; % stiffness is calculated from force by 
% dividing it by the depth

% creating the x and y coordinates which is used later to find the location
% of the tumour(s) 
x_array = x_resolution*(0:force_dim(2)-1); % x coordinate system
y_array = y_resolution*(0:force_dim(1)-1); % y coordinate system

proceed = error_check(force_data); % error_check is user-defined function 
% which checks if the data is corrupted or not 
if (proceed == "No")||(proceed == "")
    return % if they select to not proceed then the program stops
end 

%% filtering data and calculations

% filtration is a user-defined function which filtered the data to find the
% location of tumours and possible/potential growth of tumours
[tumour_data,potential_tumour_data,binary_array,size_of_tumour] = ...
    filtration(stiffness_data,force_dim,x_array,y_array,...
    x_resolution,y_resolution)

%% plotting the graph

% surface graph
figure (1)
surf(x_array, y_array, stiffness_data);
xlabel('x coordinates (mm)');
ylabel('y coordinates (mm)');
zlabel('Stiffness (N/m)');
title('Stiffness vs Coordinates');
colormap default; % colour scheme of the surface plot
rotate3d on ; % enables the user to rotate the surface plot
hold on; 
plot3(tumour_data(:,2),tumour_data(:,3),tumour_data(:,4),'ro'); % marks the 
% position of the tumours on the surface plot by drawing a red circle
if isempty(potential_tumour_data)==0
plot3(potential_tumour_data(:,2),potential_tumour_data(:,3)...
    ,potential_tumour_data(:,4),'yo'); % marks the position of potential 
% tumours on the surface plot by drawing a yellow circle
end 
hold off;

% pcolor graph
figure (2)
graph = pcolor(x_array, y_array, stiffness_data);
xlabel('x coordinates (mm)');
ylabel('y coordinates (mm)');
zlabel('Stiffness (N/m)');
title('Stiffness vs Coordinates');
colorbar; 
rotate3d off;
hold on; 
plot3(tumour_data(:,2),tumour_data(:,3),tumour_data(:,4),'ro'); % marks the 
% position of the tumours on the surface plot by drawing a red circle
if isempty(potential_tumour_data)==0
plot3(potential_tumour_data(:,2),potential_tumour_data(:,3)...
    ,potential_tumour_data(:,4),'yo'); % marks the position of potential 
% tumours on the surface plot by drawing a yellow circle
end 
hold off;

% contour graph
figure (3)
contour(x_array, y_array, stiffness_data);
xlabel('x coordinates (mm)');
ylabel('y coordinates (mm)');
zlabel('Stiffness (N/m)');
title('Stiffness vs Coordinates');
colorbar;
rotate3d off;

%% saving file

% prompts the user to select the method to save the file
save_file_prompt(tumour_data,potential_tumour_data,file_name,y_array,...
    x_array,binary_array,graph);
