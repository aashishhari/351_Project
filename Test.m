cd EN\;                             %change folder to english folder
ENfiles = dir('*.opus');            %specify files to read

x=zeros(48312,21);
y=zeros(48312,21);

i=1;

for file = ENfiles'

    temp=audioread(file.name);
    x(:,i)=temp;                    %concatenate audio clip into zero matrix x
    i=i+1;

end

ESfiles = dir('ES\');               %repeat for spanish
i=1;

for file = ESfiles'

    temp=audioread(file.name);
    y(:,i)=temp;
    i=i+1;

end


