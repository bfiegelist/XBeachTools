function ProfView(ID,Profile)
close all
current_folder = pwd;
cd('C:\Users\rf20354\Documents\Research\RC_Profiles')
load('Final_TWL_Profiles_04282022.mat');
cd(current_folder)
row = ID2row(ID);
zdat = Profile(row).zdatum;
Dlow = Profile(row).Dlow;
x = Profile(row).Xshore;
y = Profile(row).Prof;
lat = Profile(row).lat; lon = Profile(row).lon;
if y(1)>y(end)
        x = flip(x);
        y = flip(y);
end
nx = (abs(x(end) - x(1)))/0.05+1;
xnew = linspace(x(1),x(end),nx);
ynew = interp1(x,y,xnew);
j = 0;

    for i = 1:length(xnew)
        if ynew(i)>zdat && j == 0
            diff1 = abs(ynew(i-1)-zdat);
            diff2 = abs(ynew(i)-zdat);
            if diff1<diff2
                zdat2 = ynew(i-1);
                zdat_loc = xnew(i-1);
                zdat_i = i;
                j = 1;

            else
                zdat2 = ynew(i);
                zdat_loc = xnew(i);
                zdat_i = i;
                j = 1;

            end
        elseif j ==1 && ynew(i)>Dlow
            diff1 = abs(ynew(i-1)-Dlow);
            diff2 = abs(ynew(i)-Dlow);
            if diff1<diff2
                Dlow2 = ynew(i-1);
                Dlow_loc = xnew(i-1);
                Dlow_i = i;
               break      
            else
                Dlow2 = ynew(i);
                Dlow_loc = xnew(i);
                Dlow_i = i;
                break       
            end
        end
    end



slope = Profile(row).BeachSlope;

y3 = ynew(zdat_i:Dlow_i);
x3 = xnew(zdat_i:Dlow_i);
% dx = x(2)-x(1);
%  y2 = zdat:dx:Dlow;
y2 = linspace(zdat,Dlow,length(x3));
%     x2 = linspace(0, bw, length(x3));
%     x2adj = linspace(zdat_loc,Dlow_loc,length(x3));
%     y2 = slope.*x2+zdat;
rmse = rms(y2-y3);



f=figure(1);
f.Position(3:4) = [800 800];
subplot(2,1,1);
area(xnew, zdat+zeros(1,length(xnew)),-999)
hold on
area(xnew,ynew,-999)
axis([zdat_loc - 20 Dlow_loc + 20 -2 max(ynew)])
colororder([0 0.4470 0.7410;.9 .8 .7])
hold on
% x2 = linspace(0, bw, length(x3));
% x2adj = linspace(Dlow_loc-bw,Dlow_loc,length(x3));
% y2 = slope.*x2+zdat;
%plot(x2adj,y2,'r')
plot(x3,y2,'r')
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