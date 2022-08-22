% Init
meanDecInst=@(trial) cell2mat(cellfun(@(x)mean(x(trial.ROIMap),'all'), trial.instdecorr,'UniformOutput',false));
prelimUncontTrialNums = [2,5,8:20];
%prelimUncontTrialNums = [2,4,5,8,9,10,11,12];
%prelimUncontTrials={};
prelimUncontInstDec = {}; 
prelimUncontTstamps = {};
prelimUncontROI = {};
finalCumDec = {}; 
basePath = '/Volumes/ROCKET-nano/EchoDecProjectData/PrelimUncontrolled/USData_raw';
prelimUncontInst = {};
for currTrial = 1:length(prelimUncontTrialNums)
    outPath = fullfile('/Volumes/ROCKET-nano/EchoDecProjectData/PrelimUncontrolled', strcat('/USData_processed/experiment_',string(prelimUncontTrialNums(currTrial)),'.mat'));
    datIn=load(outPath);
    %prelimUncontTrials{currTrial} = datIn.outDat;
    %clear outDat
    display(currTrial)
    prelimUncontInstDec{currTrial}=meanDecInst(datIn.outDat);
    prelimUncontInst{currTrial}=datIn.outDat.instdecorr;
    prelimUncontTstamps{currTrial} = [datIn.outDat.timeArr{:}]; 
    bounds=boundsuncont{currTrial};
    tempCumDec = datIn.outDat.instdecorr{bounds(1)}; 
    for k = bounds(1):bounds(2)
        tempCumDec = max(tempCumDec, datIn.outDat.instdecorr{k});
        
    end
    finalCumDec{currTrial} = tempCumDec; 
    log10(mean(tempCumDec(datIn.outDat.ROIMap),'all'))
    prelimUncontROI{currTrial} = datIn.outDat.ROIMap;
    clear outDat
end

%%

for i = 1:numel([2,5,8:21])
    instDecT = log10(prelimUncontInstDec{i});
    tStamps=prelimUncontTstamps{i}; 
    figure(prelimUncontTrialNums(i))
    %plot(tStamps,instDecT);
    plot(instDecT);
    title(strcat('Inst decorr for preliminary uncontrolled trial #',num2str(prelimUncontTrialNums(i)) ))
        %input('next')
        input('next')
end
%%
prelimContTrialNums = [2,4:11];
prelimContTrials={};
prelimContInstDec = {};
prelimContInst={};
prelimContTstamps = {};
finalCumDecCont = {}
prelimContROI={}
basePath = '/Volumes/ROCKET-nano/EchoDecProjectData/PrelimControlled/USData_raw';
for currTrial = 1:length(prelimContTrialNums)
    outPath = fullfile('/Volumes/ROCKET-nano/EchoDecProjectData/PrelimControlled', strcat('/USData_processed/experiment_',string(prelimContTrialNums(currTrial)),'.mat'));
    datIn=load(outPath);
    prelimContInstDec{currTrial}=meanDecInst(datIn.outDat);
    prelimContInst{currTrial}=datIn.outDat.instdecorr;
    prelimContTstamps{currTrial} = [datIn.outDat.timeArr{:}]; 
    bounds=boundscont{currTrial};
    tempCumDec = datIn.outDat.instdecorr{bounds(1)}; 
    for k = bounds(1):bounds(2)
        tempCumDec = max(tempCumDec, datIn.outDat.instdecorr{k});
        
    end
    finalCumDecCont{currTrial} = tempCumDec; 
    log10(mean(tempCumDec(datIn.outDat.ROIMap),'all'))
    prelimContROI{currTrial} = datIn.outDat.ROIMap; 
    clear outDat
end
%%
%prelimContInstDecMean=meanDecInstAll(prelimContInstDec);
timeF= @(trialSet) cellfun(@(x) x.timeArr, trialSet,'UniformOutput',false);
%prelimContTstamps=;
pStart = numel(prelimUncontTrialNums);
for i = 1:length(prelimContTrialNums)
    instDecT = log10(prelimContInstDec{i});
 
    figure(i+pStart)
    dat=prelimContInstDec{i};
    %tStamps=[dat.timeArr{:}];
    %plot(tStamps,instDecT);
    plot(instDecT);
    title(strcat('Inst decorr for preliminary controlled trial #',num2str(prelimContTrialNums(i)) ))
    
end
