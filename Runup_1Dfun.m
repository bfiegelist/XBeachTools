
function Runup_1Dfun(xboutput, Ho, T, Profile_ID)
    % Compute runup values from XBeach nrugauge 1D 
    clc
    close all

    H = ncread(xboutput,'point_H');
    xz = ncread(xboutput,'point_xz');
    zs = ncread(xboutput,'point_zs');
   % load('Final_TWL_Profiles_03222022.mat');
    load  ../Final_TWL_Profiles_03222022.mat;
    MHWL = Profile(Profile_ID).zdatum; % m

    runup = zs(2,2000:4000)- MHWL;
    runup = sort(runup,'descend');
    r2 = runup(round(.02*length(runup)));
    rmax = max(runup);

    % Compute runup values using Stockdon
    B = Profile(Profile_ID).BeachSlope; % slope
    % Ho = 6; % m
    % T = 6; % s
    Lo = 9.81*T^2/(2*pi);
    R2Stock = 1.1*(.35*B*(Ho*Lo)^.5+(Ho*Lo*(.563*B^2+.004))^.5/2);

   
    lat = Profile(Profile_ID).lat; lon = Profile(Profile_ID).lon;
    figure(1)
    x = Profile(Profile_ID).Xshore;
    y = Profile(Profile_ID).Prof;
  
    plot(x,r2+MHWL+zeros(1,length(x)),'--','color','r')
    hold on
    plot(x,R2Stock+MHWL+zeros(1,length(x)),'--','color','c')
    hold on
    area(x, MHWL+zeros(1,length(x)),-999)
    hold on
    xmin = min(xz(2,:))-10; xmax = max(xz(2,:))+20;
    area(x,y,-999);colororder([0 0.4470 0.7410;.9 .8 .7]); axis([xmin xmax -1.5 4])
    legend('XBeach R2','Stockdon R2','MHWL','Beach');xlabel('Cross-shore distance (m)');
    title([num2str(lat),' ',num2str(lon)])
    txt = ['Stockdon Runup = ',num2str(round(R2Stock,3)),' m'];
    text(xmin+5,2.75,txt)
    txt = ['XBeach Runup = ',num2str(round(r2,3)),' m'];
    text(xmin+5,2.5,txt)
    txt = ['Wave properties: H_o = ',num2str(Ho),' m, T = ',num2str(T)];
    text(xmin+5,3.5,txt)
    txt = ['Beach properties: Slope = ',num2str(B)];
    text(xmin+5,3.25,txt)

%     disp(['XBeach R2 = ',num2str(r2),' m'])
%     disp(['XBeach max runup = ',num2str(rmax),' m'])
%     disp(['Stockdon R2 = ',num2str(R2Stock),' m'])
    saveas(gcf,[num2str(lat),'_',num2str(lon),'.png'])
end
