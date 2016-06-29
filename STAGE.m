clear;
load('datasave.mat'); % dataSave au début

results = {}; u = 1; data = {};
for i = 1:size(dataSave,1) % Patients iteration
    data = dataSave(i,:);
    
   % carto = data{i,4};
    %infoCarto = data{i,5};
	for ii = 1:size(data{6},1) % ROI iteration          
        roi = data{i,6}{ii,1}; % Mask loading
        roiName = data{i,6}{ii,2}

        [cartoMin, roiMin] = boiteMin3D(carto,roi); % Reduction au ROI étudié 
        cartoMin = cartoMin .* roiMin; % Background elimination
        cartoResamp = round(64*cartoMin./max(cartoMin(:))); % PET resampled 64GL

% FIRST ORDER FEATURES      
        roiVoxIdx = find(roiMin); % coordonnées voxels de la ROI
        roiVoxint = cartoMin(roiVoxIdx); % intensités voxels de la ROI
        
        volumeVox = length(roiVoxIdx); % nombre de voxels ds la ROI
        volumeML = volumeVox  * prod(infoCarto.PixelSpacing) * infoCarto.SliceThickness/ 1e3;
        sumInt = sum(roiVoxint); % somme de l'intensité des voxels de la ROI

        mini = min(roiVoxint); % minimum d'intensité
        maxi = max(roiVoxint); % maximum d'intensité
        
        p = []; % loi de probabilité
        for j=0:max(roiVoxint)
            tmp = size(find(roiVoxint==j),1)/size(roiVoxint,1);
            p = [p, tmp];
        end

        % entropy, energy, average
        entropy = 0; energy = 0; average = 0;
        for j=1:size(p,2)
            Pi = p(j);
            if Pi~=0
                entropy = entropy  + Pi * log2(Pi);
            end
            energy = energy + Pi.^2;
            average = average + j*Pi;
        end
        entropy = -entropy;
        
        % variance, skewness, entropy, SD, COV and TLG
        variance = 0; skew = 0; kurto = 0;
        for j=j:size(p,2)
            Pi = p(j);
            variance = variance + (j-average)^2 * Pi;
        end 
        SD = sqrt(variance); % standard deviation
        COV = SD/average; % coefficient of variations
        TLG = volumeML * average; % total lesion glycolysis
        
        for j=1:size(p,2)
            Pi = p(j);
            skew = skew + ((j-average)^3 * Pi)/(SD^3);
            kurto = kurto + ((j-average)^4 * Pi)/(SD^4);
        end
        
        % Sphericity
        [~, S] = surf_perso(cartoMin~=0);   
        V = size(find(cartoMin~=0),1);
        H = (1\(36*pi)) * (S^3\V^2);
        ASP = (H)^(1/3) - 1;
        spheri = 1 / (1 + ASP);
        
        fOrderStats = [volumeVox, volumeML, sumInt, mini, maxi, entropy, ...
            energy, average, SD, COV, TLG, skew, kurto, spheri];
        
        results = cat(1,results,{data{i,1}, roiName, fOrderStats});
    end  
end

