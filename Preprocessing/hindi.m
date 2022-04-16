%% Split Train & Test Data

train = readTSVData(".\hindi_commonvoice\train.tsv");
test = readTSVData(".\hindi_commonvoice\test.tsv");
clips = dir(".\hindi_commonvoice\clips\*.mp3");

train = intersect(string(vertcat(clips.name)), train.path);
test = intersect(string(vertcat(clips.name)), test.path);
train = train(1:400); % first 100 files
test = test(1:100);

for t = train'
    copyfile("./hindi_commonvoice/clips/" + t, "./HN/");
end

for t = test'
    copyfile("./hindi_commonvoice/clips/" + t, "./TestData/HindiTest/");
end

%% Sort Speakers (dev.tsv?)
data = readTSVData(".\hindi_commonvoice\dev.tsv");
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

% Sort Speakers Audio, Optional sound
for n=1:height(sp1)
    fileName = ".\hindi_commonvoice\clips\" + sp1.path{n}; 
    %[y fs] = audioread(fileName);
    %sound(y, fs);
    %pause(5);
end