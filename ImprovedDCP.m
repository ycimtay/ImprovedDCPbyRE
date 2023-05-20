
function [reconsthazyDCP] = improvedDCP(gtpath,hazypath)

gt = imread(gtpath);
hazy = imread(hazypath);

gt = imresize(gt,[600,800]);
hazy = imresize(hazy,[600,800]);


[finalDehazedOutput, Y, T, atmLight] = imreducehaze(hazy);


hazyR = im2double(hazy(:,:,1));hazyG = im2double(hazy(:,:,2));hazyB = im2double(hazy(:,:,3));


beta_teta_all = [];

mse_all_R =[];mse_all_G =[];mse_all_B =[];

for beta = 0:0.05:10
    
    
    for teta = -0.3:0.05:0.3
        
        rehazyR = im2double(finalDehazedOutput(:,:,1)).*(T.^beta)+(atmLight(1)+teta).*(1-(T.^beta));
        rehazyG = im2double(finalDehazedOutput(:,:,2)).*(T.^beta)+(atmLight(2)+teta).*(1-(T.^beta));
        rehazyB = im2double(finalDehazedOutput(:,:,3)).*(T.^beta)+(atmLight(3)+teta).*(1-(T.^beta));
       

         
        mse_all_R = [mse_all_R mse(rehazyR,hazyR)];
        mse_all_G = [mse_all_G mse(rehazyG,hazyG)];
        mse_all_B = [mse_all_B mse(rehazyB,hazyB)];
        
        beta_teta_all = [beta_teta_all [beta;teta]];
    end
end


 [v,idx_R] = min(mse_all_R);
 [v,idx_G] = min(mse_all_G);
 [v,idx_B] = min(mse_all_B);



beta_R = beta_teta_all(1,idx_R);
beta_G = beta_teta_all(1,idx_G);
beta_B = beta_teta_all(1,idx_B);


teta_R = beta_teta_all(2,idx_R);
teta_G = beta_teta_all(2,idx_G);
teta_B = beta_teta_all(2,idx_B);


ER = (im2double(finalDehazedOutput(:,:,1)).*(T.^beta_R)+(atmLight(1)+teta_R).*(1-(T.^beta_R)));
EG = (im2double(finalDehazedOutput(:,:,2)).*(T.^beta_G)+(atmLight(2)+teta_G).*(1-(T.^beta_G)));
EB = (im2double(finalDehazedOutput(:,:,3)).*(T.^beta_B)+(atmLight(3)+teta_B).*(1-(T.^beta_B)));


[clear_R1, Y, T, atmLight] = imreducehaze(ER);
[clear_G1, Y, T, atmLight] = imreducehaze(EG);
[clear_B1, Y, T, atmLight] = imreducehaze(EB);

reconsthazyDCP(:,:,1)=clear_R1;
reconsthazyDCP(:,:,2)=clear_G1;
reconsthazyDCP(:,:,3)=clear_B1;



end


