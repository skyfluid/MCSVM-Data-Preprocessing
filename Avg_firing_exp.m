clear
clc
close all

spike_readin
event = ft_read_event('mg49_10words_event.mat');

timestampspersecond = 50; % timestamp = 1ms
binsize = 1000;   % bin size = 50ms
binstime = 0;     % start time = 0ms
binetime = 950;   % end time = 2000ms

TASK_stime = 78974160/30;     % the first event begins at 78974160
POST_stime = ( (140337900/30) + 2000 );     % the last event begins at 140337900
POST_stime_2 = POST_stime + 20*60*1000;

latency = 0;
for iUnit=1:length(spike.timestamp)
    if max(spike.timestamp{iUnit}) > latency
        latency = max(spike.timestamp{iUnit});
    end
end

PRE_bin = zeros(length(spike.timestamp), ceil(TASK_stime/binsize));
TASK_bin = zeros(length(spike.timestamp), ceil((POST_stime-TASK_stime)/binsize));
POST_bin = zeros(length(spike.timestamp), ceil((latency-POST_stime)/binsize));

%for iBin=1:TASK_stime/binsize
    for iUnit=1:length(spike.timestamp)         % for each iUnit, average its firing count.

        fprintf('=== Unit %d ===\n', iUnit);

        for iStamp=1:length(spike.timestamp{iUnit}(:))
            if(spike.timestamp{iUnit}(iStamp) < TASK_stime)
                index=sub2ind(size(PRE_bin), iUnit, ceil(spike.timestamp{iUnit}(iStamp)/binsize));
                PRE_bin(index) = PRE_bin(index) + 1;

            elseif(spike.timestamp{iUnit}(iStamp) >= TASK_stime & spike.timestamp{iUnit}(iStamp) < POST_stime)
                index=sub2ind(size(TASK_bin), iUnit, ceil((spike.timestamp{iUnit}(iStamp)-TASK_stime)/binsize));
                TASK_bin(index) = TASK_bin(index) + 1;
            elseif (spike.timestamp{iUnit}(iStamp) >= POST_stime)
                index=sub2ind(size(POST_bin), iUnit, ceil((spike.timestamp{iUnit}(iStamp)-POST_stime)/binsize));
                POST_bin(index) = POST_bin(index) + 1;
            else
                fprintf('!');
            end           
        end

    end
%end


save(['AvgSpikePerSec_PRE_bin' int2str(binsize) '.mat'], 'PRE_bin');
save(['AvgSpikePerSec_TASK_bin' int2str(binsize) '.mat'], 'TASK_bin');
save(['AvgSpikePerSec_POST_bin' int2str(binsize) '.mat'], 'POST_bin');

% average
figure('name', 'POST/PRE/TASK PSTH uni');
%plot(1:199, mean(PRE_bin, 2), 1:199, mean(TASK_bin, 2), 1:199, mean(POST_bin, 2))
bar([mean(PRE_bin, 2)'; mean(TASK_bin, 2)'; mean(POST_bin, 2)']')
xlabel('iUnits')
ylabel('avg #Spikes per second')
legend('PRE', 'TASK', 'POST')
title('Avg #spike PRE/TASK/POST')
axis([0 200 0 18])
saveas(gcf, ['AvgSpikePerSec_all_bar' int2str(binsize) '.pdf'], 'pdf')


figure;
errorbar( [mean(PRE_bin, 2) mean(TASK_bin, 2) mean(POST_bin, 2)], [std(PRE_bin, 0, 2) std(TASK_bin, 0, 2) std(POST_bin, 0, 2)], 'x')
xlabel('iUnits')
ylabel('avg #Spikes per second')
legend('PRE', 'TASK', 'POST')
title('Avg & std #spike PRE/TASK/POST')
axis([0 200 0 23])
saveas(gcf, ['AvgSpikePerSec_all_Ebar' int2str(binsize) '.pdf'], 'pdf')

figure;
errorbar( mean(PRE_bin, 2), std(PRE_bin, 0, 2), 'bx')
xlabel('iUnits')
ylabel('avg #Spikes per second')
title('PRE avg & std')
axis([0 200 0 23])
saveas(gcf, ['AvgSpikePerSec_PRE_Ebar' int2str(binsize) '.pdf'], 'pdf')

figure
errorbar( mean(TASK_bin, 2), std(TASK_bin, 0, 2), 'gx')
xlabel('iUnits')
ylabel('avg #Spikes per second')
title('TASK avg & std')
axis([0 200 0 23])
saveas(gcf, ['AvgSpikePerSec_TASK_Ebar' int2str(binsize) '.pdf'], 'pdf')

figure
errorbar( mean(POST_bin, 2), std(POST_bin, 0, 2), 'rx')
xlabel('iUnits')
ylabel('avg #Spikes per second')
title('POST avg & std')
axis([0 200 0 23])
saveas(gcf, ['AvgSpikePerSec_POST_Ebar' int2str(binsize) '.pdf'], 'pdf')


%hold on

%colorbar;
%title('POST PSTH uni')
%title('PRE PSTH uni')
%title('TASK PSTH uni')
%view([0 0 ])

%saveas(gcf, 'POST_PSTH_uni.pdf', 'pdf')
%saveas(gcf, 'PRE_PSTH_uni.pdf', 'pdf')
%saveas(gcf, 'TASK_PSTH_uni.pdf', 'pdf')


%save('POST_PSTH_uni.mat', 'POST_bin');
%save('PRE_PSTH_uni.mat', 'POST_bin');
%save('TASK_PSTH_uni.mat', 'POST_bin');