function ProfViewold(ID)
%close all

current_folder = pwd;
cd('C:\Users\rf20354\Documents\Research\RC_Profiles')
load('Final_TWL_Profiles_04282022.mat');
cd(current_folder)

ID_array = zeros(length(Profile),1);
for i = 1: length(Profile)
    ID_array(i) = Profile(i).ID;
end

row = find(ID_array == ID);

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
%     if length(zdat_loc)==0
%         zdat_loc = Dlow_loc - bw;
%     end
    zdat_loc = Dlow_loc - bw;
    [value1, b_start] = min(abs(x(:)-zdat_loc));
    [value2, b_end] = min(abs(x(:)-Dlow_loc));
    slope = Profile(row).BeachSlope;
    y3 = y(b_start:b_end);
    x3 = x(b_start:b_end);
    x2 = linspace(0, bw, length(x3));
    x2adj = linspace(zdat_loc,Dlow_loc,length(x3));
    y2 = slope.*x2+zdat;
    rmse = rms(y2-y3);



f=figure(1);
f.Position(3:4) = [800 800];
subplot(2,1,1);
area(x, zdat+zeros(1,length(x)),-999)
hold on
area(x,y,-999)
axis([zdat_loc - 20 Dlow_loc + 20 -2 max(y)])
colororder([0 0.4470 0.7410;.9 .8 .7])
hold on
x2 = linspace(0, bw, length(x3));
x2adj = linspace(Dlow_loc-bw,Dlow_loc,length(x3));
y2 = slope.*x2+zdat;
plot(x2adj,y2,'r')
rmse = rms(y2-y3);
txt = ['Beach Slope RMSE = ',num2str(round(rmse,3))];
text(.05,.95,txt,'Units','normalized')
txt = ['Beach Slope = ',num2str(round(slope,3))];
text(.05,.9,txt,'Units','normalized')
title(['Transect ',num2str(ID),': ',num2str(lat),' ',num2str(lon)])
xlabel('Cross-shore distance (m)');ylabel('Elevation NAVD88 (m)')
legend('MHWL','Land','Beach Slope','Location','southeast')
subplot(2,1,2);
gp = geoplot(lat,lon,'*','color','r','MarkerSize',10);
%geolimits([lat-1 lat+1],[lon-1 lon+1])
geolimits([lat-.8 lat+.8],[lon-.8 lon+.8])
geobasemap topographic
%geobasemap satellite
end
