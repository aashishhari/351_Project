function dev = readTSVData(filename, dataLines)
%IMPORTFILE Import data from a text file
%  DEV = IMPORTFILE(FILENAME) reads data from text file FILENAME for the
%  default selection.  Returns the data as a table.
%
%  DEV = IMPORTFILE(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  filename: \\wsl$\ubuntu\home\aashishhari\351\351_Project\hi_cv\dev.tsv
%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 10);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["client_id", "path", "sentence", "up_votes", "down_votes", "age", "gender", "accents", "locale", "segment"];
opts.VariableTypes = ["categorical", "string", "string", "double", "double", "string", "string", "string", "categorical", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["path", "sentence", "age", "gender", "accents", "segment"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["client_id", "path", "sentence", "age", "gender", "accents", "locale", "segment"], "EmptyFieldRule", "auto");

% Import the data
dev = readtable(filename, opts);

end