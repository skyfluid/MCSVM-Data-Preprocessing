% 2014.05.20
% for each trial, readin spikes and do PCA for them.

clear
clc
%targets = {'FORK';};

spike_readin % load('spikeUnion.mat')

timestampspersecond = 1000; % timestamp = 1ms
binsize = 50;   % bin size = 50ms
binstime = 0;     % start time = 50ms
binetime = 1000;   % end time = 1000ms

event = ft_read_event('mg49_10words_event.mat');
j = 1;  % existing figure count

for iEvent=1:length(event)
    %if strcmp(event(iEvent).type, targets)

        fprintf('=== Event %d ===\n', iEvent);
        %bin extraction
        number_of_bins = (binetime-binstime)/binsize; % # of bins
        binMat{iEvent}.mat = zeros(length(spike.timestamp), number_of_bins);
        binMat{iEvent}.type = event(iEvent).type;
        
        for iUnit=1:length(spike.timestamp)
            stime = binstime + (event(iEvent).timestamp)/30;
            etime = stime + binsize;
            
            iBin = 1;
            k = 1;
            %fprintf('=== Unit %d ===', iUnit);
            while (stime < binetime + (event(iEvent).timestamp)/30) & k<length(spike.timestamp{iUnit}(:))                  
                
                if (spike.timestamp{iUnit}(k) < stime)
                    k = k + 1;
                elseif (spike.timestamp{iUnit}(k) >= etime)
                    stime = stime + binsize;
                    etime = etime + binsize;
                    iBin = iBin + 1;
                else
                    %fprintf('\niBin: %d, stime: %d, etime: %d', iBin, stime, etime);
                    %fprintf('%d\t', k);
                    index=sub2ind(size(binMat{iEvent}.mat),iUnit, iBin);
                    binMat{iEvent}.mat(index) = binMat{iEvent}.mat(index) + 1;
                    k = k + 1;
                end                
            end
            %fprintf('\n', iUnit);
        end
        
        %z-normalizaiton
        
        binMat{iEvent}.avg = mean(binMat{iEvent}.mat, 2);
        binMat{iEvent}.std = std(binMat{iEvent}.mat,0,2);
        
        %size(binMat{iEvent}.mat)
        %size(repmat(binMat{iEvent}.std, 1, number_of_bins))
        
        binMat{iEvent}.Qmat = (binMat{iEvent}.mat - repmat(binMat{iEvent}.avg, 1, number_of_bins)) ./ repmat(binMat{iEvent}.std, 1, number_of_bins);
            % equal to " B = zscore(A); "
        binMat{iEvent}.Qmat(isnan(binMat{iEvent}.Qmat)) = 0;    % convert NaN to 0
               
        binMat{iEvent}.Cmat = (binMat{iEvent}.Qmat * binMat{iEvent}.Qmat')/number_of_bins;
        
        % pca process
        
        [binMat{iEvent}.pcoef, binMat{iEvent}.pscore, binMat{iEvent}.plat] = princomp(binMat{iEvent}.Cmat);
    %end
end

save('binMatWord_1.mat', 'binMat');
