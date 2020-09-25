% 
% BCS-2DRP scheme: Block Compressed Sensing with 2D Random Permutation.
% This code runs the experiments for BCS-2DRP scheme. 
% BCS-2DRP scheme can be used for image Encryption-then-Compression applications. 

% for more details, see the following paper.
% Bo Zhang, Lei Yang, Kai Wang, Yuqiang Cao, "Block compressed sensing using 
% two-dimension random permutation for image Encryption-then-Compression applications, 
% 2018 14th IEEE International Conference on Signal Processing(ICSP), Beijing, China, 2018, pp. 312-316.

% If you are interested in CS-based image Encryption-then-Compression schemes, We also recomend you see the following papers.

%  [1] Bo Zhang, Di Xiao and Yong Xiang, "Robust coding of encrypted images via 2D
%  compressed sensing," IEEE Transctions on Multimedia, 2020, early access. The
%  matlab code of this paper are available at https://github.com/zhangboswjtu/2DCS-ETC.
%  [2] B. Zhang, D. Xiao, Z. Y. Zhang, L. Yang, ¡°Compressing encrypted images by using 2D compressed sensing,¡± 
%  2019 IEEE International Conferences on High Performance Computing and Communications (HPCC), Zhangjiajie, China, 2019, pp. 1914-1919.
% £¨CCFÍÆ¼öCÀà»áÒé£©
%
%  Originally written by Bo Zhang(email: zhangboswjtu@163.com), Army Engineering University. 

clc;

clear;

%  add functions and test images into the path.

addpath('C:\Users\zb\Desktop\BCS-2DRP\images');                        %    The test images

addpath('C:\Users\zb\Desktop\BCS-2DRP\WaveletSoftware');        %     WaveletSoftware

addpath('C:\Users\zb\Desktop\BCS-2DRP\mywork');                       %    functions

%%  ¡ª ¡ª ¡ª ¡ª ¡ª  ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª

%  five test images

filename = 'lenna';                                  

% filename = 'peppers';                         

% filename = 'barbara';                     
  
% filename = 'goldhill';                        

% filename = 'mandrill';                        

%  ¡ª ¡ª ¡ª ¡ª ¡ª  ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª

%  Parameters

subrate=0.5;                                        %   subrate

size_images =512;                               %    the number of rows (or columns) of the image ( square matrix only! )

block_size = 32;                                   %   block size

num_levels = 3;                                   %    Wavelet decomposition level    

max_iterations = 200;                          %     the maximum iteration number

length_of_blocks = block_size * block_size;        %    the length of block 

%  ¡ª ¡ª ¡ª ¡ª ¡ª  ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª ¡ª

% read the original image

original_filename = [ filename '.pgm'];                              

original_image = double(imread(original_filename));      

[num_rows, num_cols] = size(original_image);                   


%%  image encryption

Index = randperm(size_images) ;                %    generate a index

P1 = zeros(size_images, size_images);        %    generate two random permutation matrices for 2DRP operation

P2 = zeros(size_images, size_images);          

for i = 1: size_images  
    
P1(:, i) = eyevec(size_images, Index(i));

P2(:, i) = eyevec(size_images, Index(i));

end

%  2D random permutation (2DRP) operation

encrypted_image = P1 * original_image * P2;            

%%  Block Compressed Sensing (BCS) encoding 
    
Phi = GenerateProjection(block_size, subrate, filename);                %   generate random measurement matrix

y = CS_Encoder(encrypted_image, Phi);                                           %    BCS encoding


%%  Block Compressed Sensing (BCS) decoding 

% IHT: iterative hard thresholding 

% remark: In the paper, the reconstruction algorithm is called as modified SPL.

reconstructed_image = IHT_Decoder_for_2DRP (y, Phi, P1, P2, size_images, num_rows, num_cols, num_levels );          

PSNR = psnr(uint8(reconstructed_image), uint8(original_image));                    


 figure(1);
    
   imshow(uint8(original_image),'Border','tight');

   figure(2);
   
   imshow(uint8(encrypted_image),'Border','tight');
   
     figure(3);
   
   imshow(uint8(reconstructed_image),'Border','tight');
   

   
     
   














