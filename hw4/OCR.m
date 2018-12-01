
H=125;
W = 390;
training_H = 248;
training_W = 450;

sample1 = readraw('raw/sample1.raw', H, W);
sample2 = readraw('raw/sample2.raw', H, W);
TrainingSet = readraw('raw/TrainingSet.raw', training_H, training_W);


sample1_m = zeros(H,W,3,'uint8');
sample1_m(:,:,1) = sample1;
sample1_m(:,:,2) = sample1;
sample1_m(:,:,3) = sample1;
%imshow(sample1_m);

sample2_m = zeros(H,W,3,'uint8');
sample2_m(:,:,1) = sample2;
sample2_m(:,:,2) = sample2;
sample2_m(:,:,3) = sample2;
%imshow(sample2_m);

TrainingSet_m = zeros(training_H,training_W,3,'uint8');
TrainingSet_m(:,:,1) = TrainingSet;
TrainingSet_m(:,:,2) = TrainingSet;
TrainingSet_m(:,:,3) = TrainingSet;
%imshow(TrainingSet_m);


%% .Training Preprocessing

% Set TrainingSet to binary image
for i=1:training_H
    for j=1:training_W
        if TrainingSet(i,j) > 170
            TrainingSet(i,j) = 1;
        else
            TrainingSet(i,j) = 0;
        end
    end
end


% TrainingSet image segmentation
row_segment = zeros(1,training_H);
column_segment = zeros(1,training_W);

for i=1:training_H
    if ~isempty(find(TrainingSet(i,:) == 0)) 
        row_segment(i) = 1;
    end
end

for i=1:training_W
    if ~isempty(find(TrainingSet(:,i) == 0))
        column_segment(i) = 1;
    end
end

% Define Characters
TrainingCharacters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','!','@','#','$','%','^','&','*'];


% imshow(TrainingSet)

% Features
rowCharacters = 5;
colCharacters = 14;
totalCharacters = rowCharacters*colCharacters;

CharactersWidth = zeros(1,totalCharacters);
CharactersHeight = zeros(1,totalCharacters);
CharactersPosition = zeros(totalCharacters,4); % left/top/right/bottom

idx_LT = 1; % left-top
idx_RB = 1; % right-bottom

for i=2:training_H
    for j=2:training_W
        if row_segment(i) && column_segment(j) && ~row_segment(i-1) && ~column_segment(j-1)
            CharactersPosition(idx_LT,1) = j;
            CharactersPosition(idx_LT,2) = i;
            idx_LT = idx_LT+1;
        elseif ~row_segment(i) && ~column_segment(j) && row_segment(i-1) && column_segment(j-1)
            CharactersPosition(idx_RB,3) = j;
            CharactersPosition(idx_RB,4) = i;
            idx_RB = idx_RB+1;
        end
    end
end

% imshow(TrainingSet( CharactersPosition(1,2):CharactersPosition(1,4), CharactersPosition(1,1):CharactersPosition(1,3)))

for i=1:totalCharacters
    % shrink from top
    x=CharactersPosition(i,2);
    while isempty(find(TrainingSet(x,CharactersPosition(i,1):CharactersPosition(i,3)) == 0)) && x < CharactersPosition(i,4)
        CharactersPosition(i,2) = CharactersPosition(i,2)+1;
        x = x+1;
    end
    
    % shrink from bottom
    x=CharactersPosition(i,4);
    while isempty(find(TrainingSet(x,CharactersPosition(i,1):CharactersPosition(i,3)) == 0)) && x > CharactersPosition(i,2)
        CharactersPosition(i,4) = CharactersPosition(i,4)-1;
        x = x-1;
    end
    
    % shrink from left
    x=CharactersPosition(i,1);
    while isempty(find(TrainingSet(CharactersPosition(i,2):CharactersPosition(i,4),x) == 0)) && x < CharactersPosition(i,3)
        CharactersPosition(i,1) = CharactersPosition(i,1)+1;
        x = x+1;
    end
    
    % shrink from right
    x=CharactersPosition(i,3);
    while isempty(find(TrainingSet(CharactersPosition(i,2):CharactersPosition(i,4),x) == 0)) && x > CharactersPosition(i,1)
        CharactersPosition(i,3) = CharactersPosition(i,3)-1;
        x = x-1;
    end
    
    % counting Width and Height
    CharactersWidth(i) = CharactersPosition(i,3)-CharactersPosition(i,1);
    CharactersHeight(i) = CharactersPosition(i,4)-CharactersPosition(i,2);
end

%for i=1:totalCharacters
%    figure;
%    imshow(TrainingSet(CharactersPosition(i,2):CharactersPosition(i,4), CharactersPosition(i,1):CharactersPosition(i,3)));
%end
            
        

%% .sample1 Preprocessing

% Denoising
sample1_pre = zeros(H,W);
for i=1:H
    for j=1:W
        if sample1(i,j)>127
            sample1_pre(i,j) = 1;
        else
            sample1_pre(i,j) = 0;
        end
    end
end
%imshow(sample1_pre);

% Dilation
sample1_pre2 = sample1_pre;
hsize =1;

for i=hsize+1:H-hsize
    for j=hsize+1:W-hsize
        if sample1_pre(i,j) == 0
            for x=i-hsize:i+hsize
                for y=j-hsize:j+hsize
                    sample1_pre2(x,y) = 0;
                end
            end
        end
    end
end

%figure;
%imshow(sample1_pre2);

% Detect Positoin
sample1_column_segment = zeros(1,W);

% TrainingSet image segmentation
for i=1:W
    if ~isempty(find(sample1_pre2(:,i) == 0)) 
        sample1_column_segment(i) = 1;
    end
end

sample1Cnt = 0;

for i=2:W
    if sample1_column_segment(i) && ~sample1_column_segment(i-1)
        sample1Cnt = sample1Cnt + 1;
    end
end

Sample1Width = zeros(1,sample1Cnt);
Sample1Height = zeros(1,sample1Cnt);
Sample1Position = zeros(sample1Cnt,4); % left/top/right/bottom

idx= 1;

for i=2:W
    if sample1_column_segment(i) && ~sample1_column_segment(i-1)
        Sample1Position(idx,1) = i;
        Sample1Position(idx,2) = 1;
    elseif ~sample1_column_segment(i) && sample1_column_segment(i-1)
        Sample1Position(idx,3) = i-1;
        Sample1Position(idx,4) = H;
        idx = idx+1;
    end
end

for i=1:sample1Cnt
    % shrink from top
    x=Sample1Position(i,2);
    while isempty(find(sample1_pre2(x,Sample1Position(i,1):Sample1Position(i,3)) == 0)) && x < Sample1Position(i,4)
        Sample1Position(i,2) = Sample1Position(i,2)+1;
        x = x+1;
    end
    
    % shrink from bottom
    x=Sample1Position(i,4);
    while isempty(find(sample1_pre2(x,Sample1Position(i,1):Sample1Position(i,3)) == 0)) && x > Sample1Position(i,2)
        Sample1Position(i,4) = Sample1Position(i,4)-1;
        x = x-1;
    end
    
    % counting Width and Height
    Sample1Width(i) = Sample1Position(i,3)-Sample1Position(i,1);
    Sample1Height(i) = Sample1Position(i,4)-Sample1Position(i,2);

end
%% .sample1 Recognition

disp('Sample 1 recognition...');
for k=1:sample1Cnt
    candidate_scores = zeros(totalCharacters,3); % height-width ratio/ surface area ratio/ bit match ratio

    % calculate candidate_scores
    for i=1:62
        candidate_scores(i,1) = abs(CharactersHeight(i)/CharactersWidth(i)-Sample1Height(k)/Sample1Width(k));
        candidate = length(find(TrainingSet(CharactersPosition(i,2):CharactersPosition(i,4),CharactersPosition(i,1):CharactersPosition(i,3)) == 0))/(CharactersHeight(i)*CharactersWidth(i));
        target = length(find(sample1_pre(Sample1Position(k,2):Sample1Position(k,4),Sample1Position(k,1):Sample1Position(k,3)) == 0))/(Sample1Height(k)*Sample1Width(k));
        candidate_scores(i,2) = abs(candidate-target);
        diff = 0;
        horizontal_scale = Sample1Width(k)/CharactersWidth(i);
        vertical_scale = Sample1Height(k)/CharactersHeight(i);
        for x=CharactersPosition(i,2):CharactersPosition(i,4)
            for y=CharactersPosition(i,1):CharactersPosition(i,3)
                if TrainingSet(x,y) ~= sample1_pre2(Sample1Position(k,2)+floor((x-CharactersPosition(i,2))*vertical_scale),Sample1Position(k,1)+floor((y-CharactersPosition(i,1))*horizontal_scale))
                    diff = diff+1;
                end
            end
        end
        candidate_scores(i,3) = diff/(CharactersHeight(i)*CharactersWidth(i));
    end

    min = realmax;
    argmin = 0;
    for i=1:62 % only alphabet and numbers
        totalScore = candidate_scores(i,1)*0.45+candidate_scores(i,2)*0.8+candidate_scores(i,3)*2;
        if totalScore < min
            min = totalScore;
            argmin = i;
        end
    end

    disp(TrainingCharacters(argmin));
end


%% .sample2 Preprocessing

sample2_pre = zeros(H,W);

for i=1:H
    for j=1:W
        if sample2(i,j)==65
            sample2_pre(i,j) = 0;
        else
            sample2_pre(i,j) = 1;
        end
    end
end

% Denoising
blocksize=3;
hsize = floor(blocksize/2);
threshold=5;

for i=hsize+1:H-hsize
    for j=hsize+1:W-hsize
        rank = 0;
        for x=i-hsize:i+hsize
            for y=j-hsize:j+hsize
                if sample2_pre(x,y)==0
                    rank = rank+1;
                end
            end
        end
        if rank > threshold
            sample2_pre(i,j) = 0;
        end
    end
end

% Dilation
sample2_pre2 = sample2_pre;

for i=hsize+1:H-hsize
    for j=hsize+1:W-hsize
        if sample2_pre(i,j) == 0
            for x=i-hsize:i+hsize
                for y=j-hsize:j+hsize
                    sample2_pre2(x,y) = 0;
                end
            end
        end
    end
end

%figure;
%imshow(sample2_pre2);

% Detect Positoin
sample2_column_segment = zeros(1,W);

% TrainingSet image segmentation
for i=1:W
    if ~isempty(find(sample2_pre2(:,i) == 0)) 
        sample2_column_segment(i) = 1;
    end
end

sample2Cnt = 0;

for i=2:W
    if sample2_column_segment(i) && ~sample2_column_segment(i-1)
        sample2Cnt = sample2Cnt + 1;
    end
end

Sample2Width = zeros(1,sample2Cnt);
Sample2Height = zeros(1,sample2Cnt);
Sample2Position = zeros(sample2Cnt,4); % left/top/right/bottom

idx= 1;

for i=2:W
    if sample2_column_segment(i) && ~sample2_column_segment(i-1)
        Sample2Position(idx,1) = i;
        Sample2Position(idx,2) = 1;
    elseif ~sample2_column_segment(i) && sample2_column_segment(i-1)
        Sample2Position(idx,3) = i-1;
        Sample2Position(idx,4) = H;
        idx = idx+1;
    end
end

for i=1:sample2Cnt
    % shrink from top
    x=Sample2Position(i,2);
    while isempty(find(sample2_pre2(x,Sample2Position(i,1):Sample2Position(i,3)) == 0)) && x < Sample2Position(i,4)
        Sample2Position(i,2) = Sample2Position(i,2)+1;
        x = x+1;
    end
    
    % shrink from bottom
    x=Sample2Position(i,4);
    while isempty(find(sample2_pre2(x,Sample2Position(i,1):Sample2Position(i,3)) == 0)) && x > Sample2Position(i,2)
        Sample2Position(i,4) = Sample2Position(i,4)-1;
        x = x-1;
    end
    
    % counting Width and Height
    Sample2Width(i) = Sample2Position(i,3)-Sample2Position(i,1);
    Sample2Height(i) = Sample2Position(i,4)-Sample2Position(i,2);
    
    %figure;
    %imshow(sample2_pre2(Sample2Position(i,2):Sample2Position(i,4), Sample2Position(i,1):Sample2Position(i,3)))
end


%% .sample2 Recognition

disp('Sample 2 recognition...');


for k=1:sample2Cnt
    candidate_scores = zeros(totalCharacters,3); % height-width ratio/ surface area ratio/ bit match ratio

    % calculate candidate_scores
    for i=1:totalCharacters
        candidate_scores(i,1) = abs(CharactersHeight(i)/CharactersWidth(i)-Sample2Height(k)/Sample2Width(k));
        candidate = length(find(TrainingSet(CharactersPosition(i,2):CharactersPosition(i,4),CharactersPosition(i,1):CharactersPosition(i,3)) == 0))/(CharactersHeight(i)*CharactersWidth(i));
        target = length(find(sample2_pre(Sample2Position(k,2):Sample2Position(k,4),Sample2Position(k,1):Sample2Position(k,3)) == 0))/(Sample2Height(k)*Sample2Width(k));
        candidate_scores(i,2) = abs(candidate-target);
        diff = 0;
        horizontal_scale = Sample2Width(k)/CharactersWidth(i);
        vertical_scale = Sample2Height(k)/CharactersHeight(i);
        for x=CharactersPosition(i,2):CharactersPosition(i,4)
            for y=CharactersPosition(i,1):CharactersPosition(i,3)
                if TrainingSet(x,y) ~= sample2_pre2(Sample2Position(k,2)+floor((x-CharactersPosition(i,2))*vertical_scale),Sample2Position(k,1)+floor((y-CharactersPosition(i,1))*horizontal_scale))
                    diff = diff+1;
                end
            end
        end
        candidate_scores(i,3) = diff/(CharactersHeight(i)*CharactersWidth(i));
    end

    min = realmax;
    argmin = 0;
    for i=1:totalCharacters
        totalScore = candidate_scores(i,1)*0.45+candidate_scores(i,2)*1.15+candidate_scores(i,3)*2;
        if totalScore < min
            min = totalScore;
            argmin = i;
        end
    end

    disp(TrainingCharacters(argmin));
end