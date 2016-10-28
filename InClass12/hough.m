%create square in 100x100 space
synthetic = zeros(100,100);

%horizontal lines
synthetic(25,25:75) = 1;
synthetic(75,25:75) = 1;

%vertical lines
synthetic(25:75,25) = 1;
synthetic(25:75,75) = 1;
 
%accumulator array
aaC = 180; %% for the x's
d = ceil(sqrt(2*100*100)); %% longest distance in synthetic image
aaR = 2*d + 1; %% for the y's

aArray = zeros(aaR,aaC);
rhoArray = zeros(aaR,aaC);

for c = 1 : size(synthetic,2)
    for r = 1:size(synthetic,1)
        if(synthetic(r,c) == 1)
            for theta = 1:180
                rho = c*cosd(theta) + r*sind(theta);
                
                rho = ceil(abs(rho)) + d + 1;
                aArray(rho,theta) = aArray(rho,theta) + 1;
                rhoArray(rho,theta) = c*cosd(theta) + r*sind(theta);
            end
            
        end
    end
end

