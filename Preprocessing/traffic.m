% Predict severity of traffic conditions in one of 3 levels based on
% historic traffic data.

% Time Series Forecasting Using Deep Learning
% Plot the data, observe the frequency response
% Analyzes the spikes

% AADT - annual average daily traffic
% CAADT - commercial annual average daily traffic


%% Based on
%LSTM: https://www.mathworks.com/help/deeplearning/ug/time-series-forecasting-using-deep-learning.html
%Data Source: https://gis-mdot.opendata.arcgis.com/maps/mdot-traffic-volume-archive/about

%%

%{
data{10,1} = 0;
for n=6:16
    if(n < 10)
        M = readtable(sprintf("./Data/Traffic_Volumes_200" + n + ".csv"));
    else
        M = readtable(sprintf("./Data/Traffic_Volumes_20" + n + ".csv"));
%}
%% 

% 2006 - 2009, will have to figure out formatting other data later...
data{10, 1} = 0;
for n = 6:9
    M = readtable(sprintf("./Data/Traffic_Volumes_200" + n + ".csv"), 'Format', '%f%s%s%s%s%s%f%f%f');
    M = M(:, 2:end-1); % remove object ID and shape length.
    ids = table2array(M(:, 1:3));
    ids = strcat(ids(:,1), ids(:,2), ids(:,3));
    M.ID = ids;
    M = unique(M(:, 6:end)); % I guess this works lool
    data{n-5, 1} = sortrows(M, 'ID');
end

% innerjoin or ismember to further sort data.
h = data{1};
f = data{2};
ismember();




