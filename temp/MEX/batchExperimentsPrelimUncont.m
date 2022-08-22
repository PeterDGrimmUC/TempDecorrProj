% Init
%allTrials = [28,30,31];
%allTrials = [20];
%allTrials = [12];
allTrials = [8:23];
trials = allTrials;
basePath = '/Volumes/ROCKET-nano/EchoDecProjectData/PrelimUncontrolled/USData_raw';
for currTrial = 1:length(allTrials)
    % Load Experiment class
    experimentArr = ExperimentClass();
    % set folder
    fileTarget = fullfile(basePath,strcat('trial_',num2str(trials(currTrial))));
    dirInFile = dir(fileTarget); 
    foldersInDir = [dirInFile.isdir];
    targetDirs = dirInFile(foldersInDir);
    dirNames = arrayfun(@(x) x.name, targetDirs, 'UniformOutput', false);
    validDirs = cell2mat(cellfun(@(x) ~(isequal(x,'.') || isequal(x,'..')),dirNames,'UniformOutput',false));
    dirNames = dirNames(validDirs);
    if length(dirNames) > 1
        display('Extra folder detected!');
    end
    finalTargetDir = fullfile(fileTarget,dirNames{1});
    experimentArr.initDataFolder(finalTargetDir); 
    thisphimax = deg2rad(68/2);
    thisphimin = -thisphimax;
    thisthetamax = deg2rad(68/2);
    thisthetamin = -thisphimax;
    thisVoxelStepCart = 1; 
    thisinterFrameTime = 91; 
    thissigma = 3; 
    infoObj = experimentArr.getInitInfo();
    thisinterFrameTime = infoObj(1);
    thisphimax = deg2rad(infoObj(3)/2);
    thisthetamax = deg2rad(infoObj(4)/2);
    thisphimin = -deg2rad(infoObj(3)/2);
    thisthetamin = -deg2rad(infoObj(4)/2);
    
    experimentArr.setImagingParams(thisthetamin,thisthetamax,thisphimin,thisphimax,thisVoxelStepCart,thisinterFrameTime,thissigma)
    
    %
    experimentArr.getInitDataSet_c();
    %
    % set parameters
    x0 = 0;
    y0 = 0; 
    z0 = 52; 
    Rx_in = 0;
    Ry_in = 0;
    Rz_in = 0;
    Rx_out = 10;
    Ry_out = 10;
    Rz_out = 10;
    alphaAng = 0; 
    betaAng = 0; 
    gammaAng = 0; 
    ROIMode = 1;
    % init 
    experimentArr.setROIParams(x0,y0,z0,Rx_out,Ry_out,Rz_out,Rx_in,Ry_in,Rz_in,alphaAng,gammaAng,betaAng);
    % loop over folder to get all data sets
    tic
    while(experimentArr.addNextRawDataSet_c() ~= -1)
        toc
    end
    outDat = experimentArr.saveObj();
    outPath = fullfile('/Volumes/ROCKET-nano/EchoDecProjectData/PrelimUncontrolled', strcat('/USData_processed/experiment_',string(allTrials(currTrial)),'.mat'));
    save(outPath,'outDat','-v7.3')
    clear experimentArr
end
