% get avg inst dec in entire volume for entire experiment
avgInstDecF=@(expObj) cellfun(@(instDecCell) mean(instDecCell,'all'),expObj.instdecorr);
% get avg inst dec in ROI for entire experiment
avgInstDecROIF=@(expObj) cellfun(@(instDecCell) mean(instDecCell(instDecCell(expObj.ROIMap)),'all'),expObj.instdecorr,'UniformOutput','False');
avgInstDecROIF=@(expObj) cellfun(@(instDecCell) expObj.ROIMap,expObj.instdecorr,'UniformOutput',false);
%
%avgInstDecROIAll = @(allExp) cellfun()

%%
meanDecInst=@(trial) cell2mat(cellfun(@(x)mean(x(trial.ROIMap),'all'), trial.instdecorr,'UniformOutput',false));
meanDecInstAll = @(trialSet) cellfun(@(x) meanDecInst(x), trialSet,'UniformOutput',false);

timeF= @(trialSet) cellfun(@(x) x.timeArr, trialSet,'UniformOutput',false);

meanDecInstAll(prelimUncontTrials);
%%
instDec = meanDecInstAll(prelimUncontTrials);
%%
for i = 1:length(prelimUncontTrials)
    instDecT = log10(cell2mat(instDec(i)));
    %tStamps = [prelimUncontTrials{i}.timeArr{:}]; 
    figure(i)
    plot(tStamps,instDecT);
    title(strcat('Inst decorr for preliminary uncontrolled trial #',num2str(prelimUncontTrialNums(i)) ))
    
end