% creates a blocking region of speifc diamensions  

    for i =1:101
        xx(i,1:136)=srModel.xg';
    end
    
    for i =1:136
        yy(1:101,i)=sort(srModel.yg,'descend');
    end

    %;%define center of circle
    x0=73;
    y0=51;%
    
    
    %list how radius change with depth in km 
    rd=[0.6:0.21:4]'; %these values will change based on the depth D and d
    rd2=rd*0.86; %for ellipse define the length of the minor axis
    % convert the km values to index values
    rd =rd./0.2;
    rd2 = rd2./0.2;

%% ellipse
for kk = 1:length(rd)
        for i=1:length(srModel.yg)
            for j=1:length(srModel.xg)
                if (((j-x0)^2)/rd2(kk)^2) + (((i-y0)^2)/rd(kk)^2) <= 1;
                    meshs(kk).tf(j,i) = logical(true);
                else (((j-x0)^2)/rd2(kk)^2) + (((i-y0)^2)/rd(kk)^2) > 1;
                    meshs(kk).tf(j,i) = logical(false);

                end
            end
        end
end
    
    
%% rotated ellipse

% for kk = 1:length(rd)
%         for i=1:length(srModel.yg)
%             for j=1:length(srModel.xg)
%                 if ((((cosd(-45)*(j-x0))+(sind(-45)*(i-y0)))^2)/rd2(kk)^2) + ((((sind(-45)*(j-x0))-(cosd(-45)*(i-y0)))^2)/rd(kk)^2) <= 1
%                     meshs(kk).tf(j,i) = logical(true);
%                 else ((((cosd(-45)*(j-x0))+(sind(-45)*(i-y0)))^2)/rd2(kk)^2) + ((((sind(-45)*(j-x0))-(cosd(-45)*(i-y0)))^2)/rd(kk)^2) > 1
%                     meshs(kk).tf(j,i) = logical(false);
% 
%                 end
%             end
%         end
% end



    