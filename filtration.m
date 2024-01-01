function [tumour_data,potential_tumour_data,binary_array,size_of_tumour] = filtration(stiffness_data,force_dim,x_array,y_array,x_resolution,y_resolution)
% filtration.m is a function which removes the stiffness values which are not tumours

tumour_data = [];
potential_tumour_data = [];
binary_array = [];
size_of_tumour = [];
mean_stiffness = mean(stiffness_data,'all'); % calculates the mean from the
% stiffness data
std_stiffness = std(stiffness_data, 0,'all'); % calculates the standard 
% deviation from the stiffness data
filtered_data = stiffness_data; % makes a copy of the stiffness data for 
% further manipulation
binary_array = stiffness_data; % makes a copy of the stiffness data for 
% further manipulation
for x = 1:force_dim(1)
    for y = 1:force_dim(2)
        if (stiffness_data(x,y) - mean_stiffness) <(1*std_stiffness)
           filtered_data(x,y) = 0; % all stiffness values within 1 standard 
           % deviations are replaced by 0 to discard them
        else
           filtered_data(x,y) = stiffness_data(x,y);% if the value in the 
           % cell is greater than 1 standard deviations then it is 
           % considered within the region of tumour or a region where a
           % potential tumour could develop
        end 
    end 
end
binary_array = (stiffness_data - mean_stiffness) > (2*std_stiffness); 
% all stiffness values within 2 standard deviations are replaced by 0 to 
% discard them

tumour_array = imregionalmax(filtered_data); % uses the imregionalmax 
% function which locates the local peaks (i.e. the tumours or potential 
% tumours) from the filtered data and creates a matrix of 1s and 0s, 
% where 1s the tumour or a potential tumour
tumour_loc = find(tumour_array==1); % creates an array of linear indexes 
% where there is 1s in tumour_array
tumour_stiffness = stiffness_data(tumour_loc); % creates an array which has 
% all the stiffnesses of all the tumours/potential tumour present
potential_tumour_index = find((tumour_stiffness-mean_stiffness)...
    <=(2*std_stiffness)&(tumour_stiffness-mean_stiffness)...
    >(1*std_stiffness)); % potential tumour index finds the location where
% the tumour stiffness is less than or is at 2 standard deviation away and 
% hence this region could have a development of tumour which alert the user
potential_tumour = tumour_stiffness(potential_tumour_index);% finds the 
% current stiffness of a potential tumour growing
tumour_stiffness_index = find((tumour_stiffness-mean_stiffness)>...
    (2*std_stiffness)); % tumour stiffness index finds the location where 
% there is an existing tumour
tumour_stiffness = tumour_stiffness(tumour_stiffness_index); % finds the 
% stiffness of the tumours present in the sample
no_of_potential_tumour = length (potential_tumour); % is the number of 
% potential tumours present
no_of_tumour = length(tumour_stiffness); % is the number of 
% tumours present
[i,j] = ind2sub(size(tumour_array),tumour_loc); % converts the linear 
% indexes in [i,j] index system to find location of tumour 
x_coord_tumour = x_array(j(tumour_stiffness_index)); % creates an array 
% which has all the x coordinates of all the tumours present
y_coord_tumour = y_array(i(tumour_stiffness_index)); % creates an array 
% which has all the y coordinates of all the tumours present
x_coord_potential = x_array(j(potential_tumour_index));% creates an array 
% which has all the x coordinates of all the potential tumours present
y_coord_potential = y_array(i(potential_tumour_index)); % creates an array 
% which has all the y coordinates of all the potential tumours present
no_of_tumour = 1:no_of_tumour; % creates an array for the number 
% of tumours
no_of_potential_tumour = 1:no_of_potential_tumour; % creates an array for 
% the number of potential tumours

size_tumour_com = zeros(force_dim(1)+20,force_dim(2)+20); % creates an 
% array of zeros so that the binary data can sit in the middle and be 
% surrounded by a border of 10 0s
size_tumour_com(11:end-10,11:end-10) = binary_array;% binary array placed
% in the middle of 
for x=1:numel(x_coord_tumour)
    row = find(size_tumour_com((y_coord_tumour(x)/y_resolution)+11,...
        ((x_coord_tumour(x)/x_resolution)+1):(x_coord_tumour(x)/x_resolution)+21)==1);
    % checks for 1s in the row where the tumour is located
    column = find(size_tumour_com(((y_coord_tumour(x)/y_resolution)+1):...
        (y_coord_tumour(x)/y_resolution)+21,(x_coord_tumour(x)/x_resolution)+11)==1);
    % checks for 1s in the column where the tumour is located
        size_of_tumour(x) = (length(row)-1)*(length(column)-1)*x_resolution*y_resolution;
    % finds the area of and hence the size of the tumour 
end 

if isempty(no_of_potential_tumour)==0
    for x=1:length(no_of_potential_tumour)
        size_of_potential_tumour(x)= x_resolution*y_resolution; % creates
    % array for the size of potential tumour which will be set as a unit area 
    % as a default because the purpose is for the user to check the stiffness
    % of the potential tumour manually
    end 
    potential_tumour_data = horzcat(no_of_potential_tumour',x_coord_potential'...
    ,y_coord_potential',potential_tumour,size_of_potential_tumour');
% concatenates all the data for potential tumours
end
tumour_data = horzcat(no_of_tumour',x_coord_tumour',y_coord_tumour',...
    tumour_stiffness,size_of_tumour'); % concatenates all the data for tumours

end 