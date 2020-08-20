clc;
close all;
clear all;

%% Reading an input image

[f,p] = uigetfile('.jpg');
x = strcat(p,f);
im = imread(x);

figure, imshow(im); title('Selected Input Image');

%% Extracting the individual planes from the original image

R = im(:,:,1);
G = im(:,:,2);
B = im(:,:,3);

figure, subplot(2,2,1); imshow(im); title('Original RGB Image');
subplot(2,2,2); imshow(R); title('Red Component Image');
subplot(2,2,3); imshow(G); title('Green Component Image');
subplot(2,2,4); imshow(B); title('Blue Component Image');

figure, subplot(1,2,1); imshow(R);title('Red Component');
subplot(1,2,2); imhist(R);
figure, subplot(1,2,1); imshow(G);title('Green Component');
subplot(1,2,2); imhist(G);
figure, subplot(1,2,1); imshow(B);title('Blue Component');
subplot(1,2,2); imhist(B);

%% Generating Image Key

key_1D = keyGeneration(im);

size_key = size(key_1D)

%% ENCRYPTION PROCESS STARTS NOW

%%% Applying Discret Wavelet Transform for the individual plane of Input image
[iLLr1,iLHr1,iHLr1,iHHr1]=dwt2(R,'haar');
[iLLg1,iLHg1,iHLg1,iHHg1]=dwt2(G,'haar');
[iLLb1,iLHb1,iHLb1,iHHb1]=dwt2(B,'haar');
First_Level_Decompositioni(:,:,1)=[iLLr1,iLHr1;iHLr1,iHHr1];
First_Level_Decompositioni(:,:,2)=[iLLg1,iLHg1;iHLg1,iHHg1];
First_Level_Decompositioni(:,:,3)=[iLLb1,iLHb1;iHLb1,iHHb1];
First_Level_Decompositioni=uint8(First_Level_Decompositioni);

%Display Image
figure, subplot(1,2,1);imshow(im);title('Input Image');
subplot(1,2,2);imshow(First_Level_Decompositioni,[]);title('Wavelet based Decomposition of input image');

idwt_image(:,:,1) = uint8(idwt2(iLLr1,iLHr1,iHLr1,iHHr1,'haar'));
idwt_image(:,:,2) = uint8(idwt2(iLLg1,iLHg1,iHLg1,iHHg1,'haar'));
idwt_image(:,:,3) = uint8(idwt2(iLLb1,iLHb1,iHLb1,iHHb1,'haar'));
figure, imshow(idwt_image); title('original idwt image');

Scrambled_Image(:,:,1) = uint8(idwt2(iLHg1,iHLg1,iHHg1,iLLg1,'haar'));
Scrambled_Image(:,:,2) = uint8(idwt2(iLHb1,iHLb1,iHHb1,iLLb1,'haar'));
Scrambled_Image(:,:,3) = uint8(idwt2(iLHr1,iHLr1,iHHr1,iLLr1,'haar'));

figure, imshow(Scrambled_Image); title('Inverse Discrete wavelet transform of Scrambled image');

encrypted_image = imageProcess(Scrambled_Image,uint8(key_1D));
figure,imshow(encrypted_image); title('Final encrypted image for transmitting');

%% DECRYPTION PROCEDURE
R1 = encrypted_image(:,:,1);
G1 = encrypted_image(:,:,2);
B1 = encrypted_image(:,:,3);

figure, subplot(1,2,1); imshow(R1);title('Corresponding Red component of Encrypted image');
subplot(1,2,2); imhist(R1);
figure, subplot(1,2,1); imshow(G1);title('Corresponding Green component of Encrypted image');
subplot(1,2,2); imhist(G1);
figure, subplot(1,2,1); imshow(B1);title('Corresponding Blue component of Encrypted image');
subplot(1,2,2); imhist(B1);

%%% Applying Discret Wavelet Transform for the individual plane of Input image
[iLLr2,iLHr2,iHLr2,iHHr2]=dwt2(R1,'haar');
[iLLg2,iLHg2,iHLg2,iHHg2]=dwt2(G1,'haar');
[iLLb2,iLHb2,iHLb2,iHHb2]=dwt2(B1,'haar');
First_Level_Decompositionj(:,:,1)=[iLLb2,iLHb2;iHLb2,iHHb2];
First_Level_Decompositionj(:,:,2)=[iLLr2,iLHr2;iHLr2,iHHr2];
First_Level_Decompositionj(:,:,3)=[iLLg2,iLHg2;iHLg2,iHHg2];
First_Level_Decompositionj=uint8(First_Level_Decompositionj);

UnScrambled_Image(:,:,1) = uint8(idwt2(iLLb2,iLHb2,iHLb2,iHHb2,'haar'));
UnScrambled_Image(:,:,2) = uint8(idwt2(iLLr2,iLHr2,iHLr2,iHHr2,'haar'));
UnScrambled_Image(:,:,3) = uint8(idwt2(iLLg2,iLHg2,iHLg2,iHHg2,'haar'));

Decrypted_image = imageProcess(UnScrambled_Image,uint8(key_1D));

figure,imshow(Decrypted_image); title('Successfully Decrypted image');
