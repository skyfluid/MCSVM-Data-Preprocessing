addpath ('C:\Cortex_Project\fieldtrip-20140415')
addpath ('C:\Cortex_Project\SA_Units\Unifiles')
ft_defaults

%spike = ft_read_spike ('')
UnitCount = 1;
spike.label = [];
spike.timestamp = [];
spike.waveform = [];
filename = [];
label = [];
discard = [];

%spikeRef = ft_read_spike('p029_sort_final_01.nex');
%spike005 = ft_read_spike('C:\Cortex_Project\SA_Units\Ch005\mg49_SA_005.mat');

%readin unit infomation
load('UnitInfo.mat');

for i =1:9      %% for filename 001 to 009
    filename = ['mg49_SA_00', num2str(i), '.mat'];
    if exist(filename)
        loadfile = load(filename);
        for j = 1:length(loadfile.spike.label)
            %unitinfo{UnitCount, 2}
            if unitinfo{UnitCount, 2} ~= -1
                spike.label = [spike.label, strcat(sprintf('%s%d', 'E', i), loadfile.spike.label(j))];
                spike.timestamp = [spike.timestamp, loadfile.spike.timestamp(j)];
                spike.waveform = [spike.waveform, loadfile.spike.waveform(j)];
            else
                discard = [discard; strcat(sprintf('%s%d', 'E', i), loadfile.spike.label(j))];
            end
            
            UnitCount = UnitCount + 1;
        end
    end
end

for i =10:96      %% for filename 010 to 096
    filename = ['mg49_SA_0', num2str(i), '.mat'];
    if exist(filename)
        loadfile = load(filename);
        for j = 1:length(loadfile.spike.label)
            if unitinfo{UnitCount, 2} ~= -1
                spike.label = [spike.label, strcat(sprintf('%s%d', 'E', i), loadfile.spike.label(j))];
                spike.timestamp = [spike.timestamp, loadfile.spike.timestamp(j)];
                spike.waveform = [spike.waveform, loadfile.spike.waveform(j)];
            else
                discard = [discard; strcat(sprintf('%s%d', 'E', i), loadfile.spike.label(j))];
            end
            UnitCount = UnitCount + 1;
        end
    end
end

discard;


clear filename;
clear i;
clear j;

%spike.fsample = 600;

%save('spikeUnion.mat', '-struct', 'spike');


cfg = [];
spike = ft_spike_select(cfg, spike);