%Modified Tomolab script to conduct inversions in multiple smoothing values
%Author: Maleen Kidiwela 
smoothing=[80];

for ij=1:length(smoothing)
    
    sm = smoothing(ij);
    
    rt = 1.6;

        % Script for running' TomoLab Locally
        % Expected to run script from m-files directory
        close all; clc
        format short g


        % Set working directory and connect back to m-files
        cd '/Users/earthnote/Documents/GitHub/StingrayGIT'

        % Start pool if running in parallel
        %parpool(4);

        % INPUT
        % srModel_anis_1Dinit.mat is a inital model of 1D as starting model
        % Stingray/TomoLab Structures--These should be the TRUE inputs

        theGeometry    = which('srGeometry_orca.mat');
        theEvent       = which('srEvent_orca.mat');
        theStation     = which('srStation_orca1.mat');
        theElevation   = which('srElevation_orca_intp.mat');%srElevation_orca_newint.mat');
        theControl     = which('srControl_orca.mat');%srControl_orca.mat');
        theModel       = which('srModel_longwave2_g.mat');%srModel_anis_1Dinit.mat');
        theArrival     = which('tlArrival_adjustedunc.mat');
        thePert        = which('tlPert_orca_new.mat');

        % Load structures

        % set tlControl fields, stored locally in m-file TomoLab_control.m

        set_tlControl_orca
        save([tlControl.dir_result,'tlControl'],'tlControl')

        % Load StingRay Structures

        srControl   = load_srControl(theControl);
        srGeometry  = load_srGeometry(theGeometry);
        srElevation = load_srElevation(theElevation,srGeometry);
        srStation   = load_srStation(theStation,srGeometry);
        srEvent     = load_srEvent(theEvent,srGeometry);
        srModel     = load_srModel(theModel,srControl,srGeometry,srElevation);
        srArc       = arc_prep(srControl.arcfile, srModel.gx, srModel.gy, srModel.gz);
        
        %% for isotropic pg dpb
        srControl.tf_anisotropy = 0;
        tlControl.anisotropy.P.tf_invert =0; %for anisotropy
        tlControl.slowness.P.tf_invert = 1;
        srControl.tf_line_integrate=0; % tf_anisotropy needs to be true for this
        tlControl.VpVsOption = 0;
        
        %%
        % Load TomoLab structures
        tlArrival = load_tlArrival(theArrival);
        tlPert    = load_tlPert(thePert,srModel);

        % Map perturbational nodes to slowness model
        [tlPert]  = buildMap(srModel,tlPert);

        %adding a code to fix the offset in BRA05 no matter which change
        counted = strcmp(tlArrival.station,'BRA05');
        numbers = [1:length(tlArrival.eventid)]';
        numbers = numbers(counted);
        tlArrival.time(min(numbers):max(numbers)) = tlArrival.time(min(numbers):max(numbers))+0.16950;


        % CALL TOMOLAB

        tlControl.slowness.P.penalty              = 1.6;%sm/rt;%Lagrangian multiplier for model norm
        tlControl.slowness.P.smoothing_xy         = 80;%sm;%80; %Lagrangian multiplier for model smoothness in the horizontal direction
        tlControl.slowness.P.smoothing_z          = 80;%sm;%80 %Lagrangian multiplier for model smoothness in the vertical direction


        stime = tic;
        [srModel, tlMisfit]=...
            TomoLab ...
            (srControl, srStation, srEvent, srModel, srArc, ...
            tlControl, tlArrival, tlPert);
        rtime = toc(stime);
        disp(['Total run time is: ',num2str(rtime),' s.']);

        % Store runtime and save
        tlControl.runTime = rtime;
        save([tlControl.dir_result,'tlControl'],'tlControl')
        
        n= tlControl.dir_result(70:82);
        %To add to the table of inversions
        %run = tlControl.dir_result(70:83); 
         %tlTable
        clearvars -except smoothing damping sm dp rt ratio ij


end
