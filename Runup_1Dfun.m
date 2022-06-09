
function Runup_1Dfun(xboutput, Ho, T, Profile_ID)
    % Compute runup values from XBeach nrugauge 1D 
    clc
    close all
        
    Profile_ID = ID2row(Profile_ID);
    full_zs = ncread(xboutput,'zs');
  
    point_xz = ncread(xboutput,'point_xz');
    point_zs = ncread(xboutput,'point_zs');
    current_folder = pwd;
    cd('C:\Users\rf20354\Documents\Research\RC_Profiles')
    load('Final_TWL_Profiles_04282022.mat');
    cd(current_folder)
    MHWL = Profile(Profile_ID).zdatum; % m
    stable = round(length(point_zs)/2);
    runup = point_zs(2,stable:end);
    runupx = point_xz(2,stable:end);
    [runup,I] = sort(runup,'descend');
    runupx = runupx(I);
    maxindex = I(1)
    timemax = full_zs(:,maxindex);
  
    
     XBrmax = runup(1);
     XBrmax_x = runupx(1);
     maxx = max(runup)
   
    % Compute runup values using Stockdon
    B = Profile(Profile_ID).BeachSlope; % slope
    % Ho = 6; % m
    % T = 6; % s
    Lo = 9.81*T^2/(2*pi);
    R2Stock = 1.1*(.35*B*(Ho*Lo)^.5+(Ho*Lo*(.563*B^2+.004))^.5/2);

    row = Profile_ID;
    lat = Profile(row).lat; lon = Profile(row).lon;
    x = Profile(row).Xshore;
    y = Profile(row).Prof;
    if y(1)>y(end)
        x = flip(Profile(row).Xshore);
        y = flip(Profile(row).Prof);
    end
    zdat = Profile(row).zdatum;
    zdat_loc = x(find(y==zdat));
    bw = Profile(row).BeachW;
    Dlow = Profile(row).Dlow;
    Dlow_loc = x(find(y==Dlow));
    slope = Profile(row).BeachSlope;
    y3 = y(find(y==zdat):find(y==Dlow));
    x3 = x(find(y==zdat):find(y==Dlow));
    x2 = linspace(0, bw, length(x3));
    x2adj = linspace(Dlow_loc-bw,Dlow_loc,length(x3));
    y2 = slope.*x2+zdat;
    rmse = rms(y2-y3);

 
    lat = Profile(Profile_ID).lat; lon = Profile(Profile_ID).lon;
    f = figure(1);
    f.Position(3:4) = [600 600];
    x = load('x.grd');
    y = load('bed.dep');
    subplot(2,1,1);
    plot(x,XBrmax+zeros(1,length(x)),'--','color','r','LineWidth',1.5)
    hold on
    plot(x,R2Stock+MHWL+zeros(1,length(x)),'--','color','c','LineWidth',1.5)
    hold on
    area(x, MHWL+zeros(1,length(x)),-999)
    hold on
    xmin = min(point_xz(2,:))-10; xmax = max(point_xz(2,:))+30;
    area(x,y,-999);colororder([0 0.4470 0.7410;.9 .8 .7]); 
    %axis([xmin xmax -1.5 4])
    axis([zdat_loc - 20 Dlow_loc + 20 -2 max(y)+1])
    x2 = linspace(0, bw, length(x3));
    x2adj = linspace(Dlow_loc-bw,Dlow_loc,length(x3));
    y2 = slope.*x2+zdat;
    plot(x2adj,y2,'g','LineWidth',1.5)
    rmse = rms(y2-y3);
    legend('XBeach','Stockdon','MHWL','Beach','Beach slope','Location','southeast');xlabel('Cross-shore distance (m)');
    ylabel('Elevation NAVD88 (m)');
    title(['Transect ',num2str(Profile_ID),': ',num2str(lat),' ',num2str(lon)])
    txt = ['Stockdon Runup = ',num2str(round(R2Stock,3)),' m'];
    text(.05,.95,txt,'Units','normalized')
    txt = ['XBeach Runup = ',num2str(round(XBrmax-MHWL,3)),' m'];
    text(.05,.875,txt,'Units','normalized')
    txt = ['H_o = ',num2str(Ho),' m, T = ',num2str(T),' s'];
    text(.05,.78,txt,'Units','normalized')
    txt = ['Beach Slope = ',num2str(round(B,4)),', RMSE = ',num2str(round(rmse,3))];
    text(.05,.71,txt,'Units','normalized')

    subplot(2,1,2);
    gp = geoplot(lat,lon,'*','color','r','MarkerSize',10);
    geolimits([lat-3 lat+3],[lon-5 lon+5])
    geobasemap topographic
    saveas(gcf,[num2str(lat),'_',num2str(lon),'.png'])
    
end
