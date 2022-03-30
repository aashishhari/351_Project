% cv corpus 8.0 - 2022 01-19 & Hindi
% dir name: hi

data = readTSVData(".\hindi_commonvoice\dev.tsv");
hd = head(data);
data.group = findgroups(data.client_id);
% Speakers
sp1 = data(data.group==1,2:3);
sp2 = data(data.group==2,2:3);
sp3 = data(data.group==3,2:3);
sp4 = data(data.group==4,2:3);
sp5 = data(data.group==5,2:3);
sp6 = data(data.group==6,2:3);
sp7 = data(data.group==7,2:3);
sp8 = data(data.group==8,2:3);
sp9 = data(data.group==9,2:3);
sp10 = data(data.group==10,2:3);

speakers = unique(data(:, [6 7 11]), 'rows');
speakers = sortrows(speakers, 3);


% Sort Speakers Audio
for n=1:height(sp1)
    fileName = ".\hindi_commonvoice\clips\" + sp1.path{n}; 
    %[y fs] = audioread(fileName);
    %sound(y, fs);
    %pause(5);
end
