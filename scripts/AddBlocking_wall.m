%creates a wall that only lets Pg arrivals to pass through 

for i = 1:101
    
    srModel.x(i,:)=srModel.xg';
    
end

for i=1:136
    
    srModel.y(:,i)=srModel.yg;

end

%define center of the rotation 
Vx = 2.4;
Vy = 0;

for station= 1:length(srStation.name)
    
    Sx = srStation.x(station);
    Sy = srStation.y(station);
    
    for j = 1:length(srModel.yg)
        
        for k = 1:length(srModel.xg)
            
            Px=srModel.x(j,k);
            Py=srModel.y(j,k);
            
            G =(Vy-Sy)/(Vx-Sx);
            D= abs((-Px/G)+Vy+(Vx/G)-Py)/sqrt((-1/G)^2+(-1)^2);
            
            if D<=0.6
                for kj=1:18
                    Block(kj).stat(station).tf(j,k) = true;
                end
                
            else
                for kj=1:18
                    Block(kj).stat(station).tf(j,k) = false;
                end
            end
            
            
        end
        
    end
    
end



Blockwc = Block;
%creating a new block that has different diamensions other than a cone
AddBlocking_cyllinder

for jk=1:18
    
    for z= 1:length(srStation.name)
        if jk ~= 18
            C = Blockwc(jk).stat(z).tf;
            B = C & meshs(jk).tf';
            C(B) = false;
            Blockwc(jk).stat(z).tf = C;
        end

    end
end

