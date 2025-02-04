function [srModel, tlMisfit] = TomoLab ...
    (srControl, srStation, srEvent, srModel, srArc, ...
    tlControl, tlArrival, tlPert)

%  [srModel tlArrival, tlPert, tlMisfit] = TomoLab ...
%              (srControl, srGeometry, srStation, srEvent, srModel, srArc, ...
%               tlControl, tlArrival, tlPert)
%
%  Controls main inversion loop, includes:  Ray tracing, calcuation of
%  partials, addition of smoothing and inversion.

%  Copyright 2010 Blue Tech Seismics, Inc.

% Initialize the tlMisfit structure, by calling with [];

[tlMisfit] = iterateTL(tlControl, tlPert, []);

%  Load srPhase structure; defines phases that can be modeled

load('srPhase.mat');
%add new phase
srPhase(4).phase={'dPb'};srPhase(4).phasetype = 1;
srPhase(4).model={'P'};srPhase(4).interface =[];

nraysets   = length(srPhase);

%%  Check sr and tl logicals to find obvious mismatches

check_srtlControl

%% Preallocated A0_sub and tlMisfit_sub for nraysets (and eventually event
%  types as well.

A0_sub(nraysets).A0         = [];
tlMisfit_sub(nraysets).bvec = [];

for i = 1:nraysets
    A0_sub(i).A0 = [];
    tlMisfit_sub(i).bvec     = [];
    tlMisfit_sub(i).res      = [];
    tlMisfit_sub(i).ptr      = [];
    tlMisfit_sub(i).ttime    = [];
    tlMisfit_sub(i).inode    = [];
    tlMisfit_sub(i).ray_minz = [];
    tlMisfit_sub(i).icntTT   = 0;
    tlMisfit_sub(i).zssqr    = 0;
    tlMisfit_sub(i).wssqr    = 0;
    tlMisfit_sub(i).sumsd    = 0;
    tlMisfit_sub(i).nssqr    = 0;
end

%%  Main iteration loop.

while (tlMisfit.more_its)
    
    display(['Top of Loop: Iteration = ', num2str(tlMisfit.niter)])
    
    %  Forward Problems
    
    %%  EventType 1 (airguns)
    
    aEventType = 1;
    
    % Loop over planes of srPhase to trace groups of rays (e.g., P, Pn, Pg)
    % Outer loop is over stations
    
    for i = 1:nraysets
        
        aPhase       = srPhase(i).phase;
        [subArrival] = subset_tlArrival(tlArrival, aPhase, [], [], aEventType);
        
        if ~isempty(subArrival.num)
            
            disp('Beginning forward problem for Type 1 (airgun) events. ')
            disp(['Phase set: ',cell2string(aPhase)])
            
            [A0_sub_i, tlMisfit_sub_i] = ForwardTL_initStation(aPhase, aEventType, ...
                srControl, srStation, srEvent, srModel, srArc, ...
                tlControl, tlArrival, tlPert, tlMisfit.niter);
            tlMisfit_sub(i) = tlMisfit_sub_i;
            A0_sub(i).A0 = A0_sub_i;
        end
    end
    
    %%  EventType 2 (local borehole).  Outer loop is over events.
        
    aEventType   = 2;
    
    for i =1:nraysets
        
        aPhase       = srPhase(i).phase;
        [subArrival] = subset_tlArrival(tlArrival, aPhase, [], [], aEventType);
        
        if ~isempty(subArrival.num)
            
            disp('Beginning forward problem for Type 2 (local borehole) events')
            disp(['Phase set: ',cell2string(aPhase)])

            [A0_sub_i, tlMisfit_sub_i] = ForwardTL_initEvent(aPhase, aEventType, ...
                srControl, srStation, srEvent, srModel, srArc, ...
                tlControl, tlArrival, tlPert, tlMisfit.niter);
            tlMisfit_sub(i) = tlMisfit_sub_i;
            A0_sub(i).A0 = A0_sub_i;            
        end
    end
    
    %%  EventType 3 (regional boreholes).  Outer loop is over events
    
    aEventType   = 3;
    [subArrival] = subset_tlArrival(tlArrival, aPhase, [], [], aEventType);
    
    if ~isempty(subArrival.num)
        disp('Beginning forward problem for Type 3 (airgun) events')
        disp('Not implemented yet')
        keyboard
    end
      
    %% Concatenate A0's and tlMisfit's.
    %  This can be done later as more forward problems are added to the mix.
    
    A0                = cat(1,A0_sub(:).A0);
    tlMisfit.bvec     = cat(1,tlMisfit_sub(:).bvec);
    tlMisfit.res      = cat(1,tlMisfit_sub(:).res);
    tlMisfit.ptr      = cat(1,tlMisfit_sub(:).ptr);
    tlMisfit.ttime    = cat(1,tlMisfit_sub(:).ttime);
    tlMisfit.inode    = cat(1,tlMisfit_sub(:).inode);
    tlMisfit.ray_minz = cat(1,tlMisfit_sub(:).ray_minz);
    tlMisfit.icntTT   = sum([tlMisfit_sub.icntTT]);
    tlMisfit.zssqr    = sum([tlMisfit_sub.zssqr]);
    tlMisfit.wssqr    = sum([tlMisfit_sub.wssqr]);
    tlMisfit.sumsd    = sum([tlMisfit_sub.sumsd]);
    tlMisfit.nssqr    = sum([tlMisfit_sub.nssqr]);
    tlMisfit.icntTT   = sum([tlMisfit_sub.icntTT]);
    
    %  Evaluate the travel time variance.
    
    tlMisfit.zssqr = tlMisfit.zssqr/tlMisfit.nssqr;
    tlMisfit.wssqr = sqrt(tlMisfit.wssqr/tlMisfit.sumsd);
    
    %  Evaluate DWS.  
    %  Debugged for isotropic DWS
    %  DWS for anisotropy is not correct, values are +/-; commented out.
    %  DWS for interface not debugged; commented out.
    
    DWS = full(sum(A0));
    
    if tlControl.slowness.P.tf_invert
        tlPert.U.P.dws = DWS(tlPert.U.P.Aj(1)  : tlPert.U.P.Aj(2));
        tlPert.U.P.dws = reshape(tlPert.U.P.dws, tlPert.U.P.nx, tlPert.U.P.ny, tlPert.U.P.nz);
    end
    
    if tlControl.slowness.S.tf_invert
        tlPert.U.S.dws = DWS(tlPert.U.S.Aj(1)  : tlPert.U.S.Aj(2));
        tlPert.U.S.dws = reshape(tlPert.U.S.dws, tlPert.U.S.nx, tlPert.U.S.ny, tlPert.U.S.nz);
    end
    
%     if tlControl.anisotropy.P.tf_invert
%         tlPert.A.P.dws = ( DWS(tlPert.A.P.Aj_A(1): tlPert.A.P.Aj_A(2)) + ...
%                            DWS(tlPert.A.P.Aj_B(1): tlPert.A.P.Aj_B(2)) )/2;
%         tlPert.A.P.dws = reshape(tlPert.A.P.dws, tlPert.A.P.nx, tlPert.A.P.ny, tlPert.A.P.nz);
%                  
%     end
%     
%     for i = 1:length(tlControl.interface)
%         if tlControl.interface(i).tf_invert
%             tlPert.I(i).dws = DWS(tlPert.I(i).Aj(1):tlPert.I(i).Aj(2));
%             tlPert.I(i).dws = reshape(tlPert.I(i).dws,tlPert.I(i).nx,tlPert.I(i).ny);
%         end
%     end

    %  Clear unused variables
    save([tlControl.dir_result,'/tlMisfit_it',num2str(tlMisfit.niter)],'tlMisfit')
    %maleen added the above line to save tlMisfit before inversion^^^^
    clear A0_sub A0_sub_i
    
    %% Inverse Problem (note that by calling with srEvent, will be solving
    %  for station statics 
    
    if ~tlControl.statics.tf_invert_events
        [tlPert] = InverseTL(tlControl, tlPert, tlMisfit, A0);
    elseif tlControl.statics.tf_invert_events
        [tlPert, srEvent] = InverseTL(tlControl, tlPert, tlMisfit, A0, srEvent);
    end
    clear A0
    
    % Plots for error checking
    %{
    %  Plot the perturbational model
    
    for ip = 1:1:21
        pcolor(tlPert.U.P.x,tlPert.U.P.y,squeeze(tlPert.U.P.du(:,:,ip))')
        shading interp
        colorbar
        %caxis([min(tlPert.U.P.du(:)) max(tlPert.U.P.du(:))])
        title(['Depth: ',num2str(tlPert.U.P.z(ip)),' km'])
        axis image
        hold on
%         plot(srEvent.x,srEvent.y,'ro','MarkerSize',10,'MarkerFaceColor','w')
        plot(srStation.x,srStation.y,'.')
        pause
    end
    %}
    
    %% Update the slowness model.
    
    if tlControl.slowness.P.tf_invert
        [srModel]  = updateModel(srModel,tlPert,'P');
    end

    if tlControl.slowness.S.tf_invert
        [srModel]  = updateModel(srModel,tlPert,'S');
    end

    % Update anisotropy
    
    if tlControl.anisotropy.P.tf_invert
        [srModel] = updateModel_anis(srModel,tlPert);
    end
    
    % Update interface
    
    for i = 1:length(tlControl.interface)
        if tlControl.interface(i).tf_invert
            [srModel] = updateModel_interface(srModel,tlPert,tlControl.interface(i).id,'P');
        end
    end
      
    %  Write the results for this iteration
    
    save([tlControl.dir_result,'/srModel_it',num2str(tlMisfit.niter)],'srModel')
    save([tlControl.dir_result,'/tlMisfit_it',num2str(tlMisfit.niter)],'tlMisfit')
    save([tlControl.dir_result,'/tlPert_it',num2str(tlMisfit.niter)],'tlPert')
 
    
    if tlControl.statics.tf_invert_events
        save([tlControl.dir_result,'/srEvent',num2str(tlMisfit.niter)],'srEvent')
    end
   
    % Update iteration variables, make decision.
    
    [tlMisfit] = iterateTL(tlControl, tlPert, tlMisfit);
    
    % Plots for error checking
    %{
    %  Plots for error checking
    
    hold on;plot(1./squeeze(srModel.P.u(1,1,:)),'co-')
    plot(1./squeeze(srModel_old.u(1,1,:)),'bo-')
    figure
    
    % uinit = srModel_old.P.u(:,:,:);
    % uend  = srModel.P.u(:,:,:);
    % udiff = uend-uinit;
    % uu    = squeeze(udiff(:,142,:));
    % vs     = squeeze(srModel_old.P.u(:,142,:).^(-1));
    % subplot(211)
    % pcolor(srModel_old.xg,srModel_old.zg,vs');
    % shading interp
    % xlabel('Distance, km','fontsize',18)
    % ylabel('Depth, km','fontsize',18)
    % set(gca,'fontsize',18)
    % %     clabel(cs)
    % axis image
    % colorbar
    
    vinit = srModel_old.P.u(:,:,:).^(-1);
    vend  = srModel.P.u(:,:,:).^(-1);
    vdiff = vend-vinit;
    ky = 50;
    vv    = squeeze(vdiff(:,ky,:));
    vf    = squeeze(srModel.P.u(:,ky,:).^(-1));
    
    for ip = 1:2:srModel.nz
        subplot(211)
        foo=vinit(:);
        I= foo>3;
        foo(I)=5;
%         vinit=reshape(foo,284,208,71);
        foo1=vinit(:,:,ip);
        foo1=foo1(:);
        foo2=vend(:,:,ip);foo2=foo2(:);
        cmin = min([foo1;foo2]);
        cmax = max([foo1;foo2]);
        pcolor(srModel.xg,srModel.yg,squeeze(vinit(:,:,ip))')
        shading interp
        colorbar
        caxis([cmin cmax])
        
        title(['Depth: ',num2str((ip-1)*0.05),' km'])
        colormap(flipud(jet))
        subplot(212)
         pcolor(srModel.xg,srModel.yg,squeeze(vend(:,:,ip))')
        shading interp
        colorbar
        caxis([cmin cmax])
        title(['Depth: ',num2str((ip-1)*0.05),' km'])
        colormap(flipud(jet))
        pause
    end
    
    subplot(211)
    pcolor(srModel_old.xg,srModel_old.zg,vf')
    shading interp
    xlabel('Distance, km','fontsize',18)
    ylabel('Depth, km','fontsize',18)
    set(gca,'fontsize',18)
    %     clabel(cs)
    axis image
    colorbar
    
    subplot(212)
    pcolor(srModel_old.xg,srModel_old.zg,vv');
    shading interp
    xlabel('Distance, km','fontsize',18)
    ylabel('Depth, km','fontsize',18)
    set(gca,'fontsize',18)
    %     clabel(cs)
    axis image
    colorbar
    
    % srModel = srModelnew
    
    drawnow
    %}
    
end  % loop for iterations












