function [nonhx, nonhz] = NonhGrid(ID,T)
current_folder = pwd;
cd('C:\Users\rf20354\Documents\Research\RC_Profiles')
load('Final_TWL_Profiles_04282022.mat');
cd(current_folder)
row = ID2row(ID);
Lo = 9.81*T(1)^2/(2*pi);
Tavg = mean(T)
 if Profile(row).Xshore(1)==0
          xgr = Profile(row).Xshore;
          zgr = Profile(row).Prof;
         else
          xgr = flip(Profile(row).Xshore);
          zgr = flip(Profile(row).Prof);
 end
%[nonhx, nonhz] = xb_grid_xgrid(xgr,zgr,'dxmax',4,'Tm',T(1),'nonh',1,'dxmin',0.25,'ppwl',30);
[nonhx, nonhz] = xb_grid_xgrid(xgr,zgr,'dxmax',4,'Tm',Tavg,'nonh',1,'dxmin',0.25);
end
