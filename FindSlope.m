function [slope,dx,dxrun] = FindSlope(ID,datum)
current_folder = pwd;
cd('C:\Users\rf20354\Documents\Research\RC_Profiles')
load('Final_TWL_Profiles_04282022.mat');
cd(current_folder)
row = ID2row(ID);
x = Profile(row).Xshore;
z = Profile(row).Prof;
if z(1)>z(end)
    x = flip(x);
    z = flip(z);
end
[nonhx, nonhz] =  xb_grid_xgrid2(xgr,zgr,'dxmax',5,'Tm',Tprun,'nonh',1,'dxmin',0.25,'wl',MLLWrun,'zdry',MLLWrun,'dxdry',0.25);
for i = 1:length(xrun)
   if zrun(i) > datum
        dxrun = (xrun(i+1)-xrun(i));
        break
   end
end

[nonhx, nonhz] = xb_grid_xgrid(x,z,'dxmax',4,'Tm',6,'nonh',1,'dxmin',0.25,'wl',datum,'zdry',datum-.5,'dxdry',0.25);
for i = 1:length(nonhx)
   if nonhz(i) > datum
        slope = (nonhz(i+10)-nonhz(i-10))/(nonhx(i+10)-nonhx(i-10));
        dx = (nonhx(i+10)-nonhx(i-10));
        break
   end
end
end
