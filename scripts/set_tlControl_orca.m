% Create tlControl


work_dir = '/Users/earthnote/Documents/GitHub/StingrayGIT/BRAVOSEIS_run';
% General inversion parameters

tlControl.maxit       = 6;
%%Maximum number of ray-tracing/inversion itereation

tlControl.lsqr_maxit  = 3000;
%Maximum number of iterations to use in LSQR

tlControl.jump_tf     = 0;
%true(1) is jumping, false(0) is creeping

tlControl.dir_result  = [work_dir,'/tlOutput/',datestr(now,'yymmdd_HHMMSS'),'/'];
%path where results of inversion will be written

%  P-wave slowness inversion parameters

tlControl.slowness.P.tf_invert            = 1; %true(1) inverts for slowness
tlControl.slowness.P.penalty              = 1.6;%sm/rt;%Lagrangian multiplier for model norm
tlControl.slowness.P.smoothing_xy         = 80;%sm;%80; %Lagrangian multiplier for model smoothness in the horizontal direction
tlControl.slowness.P.smoothing_z          = 80;%sm;%80 %Lagrangian multiplier for model smoothness in the vertical direction

%  Anisotropy inversion parameters (only P-wave currently)

tlControl.anisotropy.P.tf_invert          = 0; % true(1) inverts for azimuthal
tlControl.anisotropy.P.penalty            = 1;%sm/rt;
tlControl.anisotropy.P.smoothing_xy       = 3000;%sm;%Lagrangian multiplier for model smoothness in the horizontal direction
tlControl.anisotropy.P.smoothing_z        = 3000;%sm;%Lagrangian multiplier for model smoothness in the vertical direction

tlControl.slowness.S.tf_invert = 0;

%  Interface inversion parameters
% 
 tlControl.interface(1).tf_invert        = 0; %true(1) inverts for slowness; false(0) keeps slowness fixed
% tlControl.interface(1).name             = {'Moho'}; % Name of the interface causing either reflection or conversion.  NOTE:  Must be cell array, e.g. {?Moho?}.
% tlControl.interface(1).id               = 1; %Unique interface id.
% tlControl.interface(1).penalty          = .001; %Lagrangian multiplier for norm of interface perturbations
% tlControl.interface(1).smoothing_xy     = 3000; %Lagrangian multiplier for interface smoothness in the horizontal direction



% Statics inversion parameters
tlControl.statics.tf_invert_events      = 0; %true(1) inverts for event statics
tlControl.statics.tf_invert_stations    = 0; %true(1) inverts for station statics
% 
% %  Ray path I/O on first iteration
% 
 tlControl.srRays.tf_in_tt               = 0; % true(1) will read in srRays on first iteration 
 tlControl.srRays.tf_out_tt              = 0; % true(1) will write out srRays on first iteration
 tlControl.srRays.dir_in_tt              = [work_dir,'/srOutput/']; % path where rays will be read.
 tlControl.srRays.dir_out_tt             = [work_dir,'/srOutput/']; % path where rays will be written

%%  Create 'files' field and store paths used for this run
%   This cell and following cells usually do not have to be changed

tlControl.('files') = [];
tlControl.files.('Control')   = theControl;
tlControl.files.('Geometry')  = theGeometry;
tlControl.files.('Station')   = theStation;
tlControl.files.('Model')     = theModel;
tlControl.files.('Elevation') = theElevation;
tlControl.files.('Event')     = theEvent;
tlControl.files.('Arrival')   = theArrival;
tlControl.files.('Pert')      = thePert;
tlControl.('Run_Date')        = datestr(now);

%% Create paths and fix permissions

%  Result dir

A = exist(tlControl.dir_result,'dir');
if A == 7
    error(['Directory exists',tlControl.dir_result])
elseif A == 0
    mkdir(tlControl.dir_result);
    eval(['!chmod a+wrx ',tlControl.dir_result])
end

% Ray output directory
 
A = exist(tlControl.srRays.dir_out_tt,'dir');
if A == 7
    display(['Directory exists',tlControl.srRays.dir_out_tt])
    eval(['!chmod a+wrx ',tlControl.srRays.dir_out_tt])
elseif A == 0
    mkdir(tlControl.srRays.dir_out_tt);
    eval(['!chmod a+wrx ',tlControl.srRays.dir_out_tt])
end

%%  Display structure

display(tlControl)
display(tlControl.files)