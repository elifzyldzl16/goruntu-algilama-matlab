%% 
web = webcam();

faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');

noseDetector  = vision.CascadeObjectDetector('Nose', 'MergeThreshold', 20);
eyeDetector   = vision.CascadeObjectDetector('EyePairBig', 'MergeThreshold', 30);
mouthDetector = vision.CascadeObjectDetector('Mouth', 'MergeThreshold', 25);

% ---- 5 saniye boyunca hiçbir şey yapmadan kamera çalışsın ----
tic; 
while toc < 5
    snapshot(web);   % kamerayı ısıtıyor
end

% ---- 5 saniye sonunda tek kare al ----
frame = snapshot(web);
gray = rgb2gray(frame);

% ---- Yüz tespit ----
faceBox = step(faceDetector, gray);

if ~isempty(faceBox)
    face = faceBox(1,:);                          % ilk yüz
    faceImage = imcrop(gray, face);               % yüz bölgesi

    % ---- Göz, burun ve ağız tespit ----
    eyes  = step(eyeDetector,  faceImage);
    nose  = step(noseDetector, faceImage);
    mouth = step(mouthDetector,faceImage);

    % ---- Koordinatları geri ekle ----
    eyes(:,1:2)  = eyes(:,1:2)  + face(1:2);
    nose(:,1:2)  = nose(:,1:2)  + face(1:2);
    mouth(:,1:2) = mouth(:,1:2) + face(1:2);

    % ---- Çiz ----
    frame = insertObjectAnnotation(frame,"rectangle",face,"Face");

    if ~isempty(eyes)
        frame = insertObjectAnnotation(frame,"rectangle",eyes(1,:),"Eyes");
    end
    if ~isempty(nose)
        frame = insertObjectAnnotation(frame,"rectangle",nose(1,:),"Nose");
    end
    if ~isempty(mouth)
        frame = insertObjectAnnotation(frame,"rectangle",mouth(1,:),"Mouth");
    end
end

imshow(frame);
title(" fotoğraf");
