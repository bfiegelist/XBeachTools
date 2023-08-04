function [xnew, ynew] = RefineTransectold(ID,quality)
current_folder = pwd;
cd('C:\Users\rf20354\Documents\Research\RC_Profiles')
load('Final_TWL_Profiles_04282022.mat');
cd(current_folder)

row = ID2row(ID);
x = Profile(row).Xshore;
y = Profile(row).Prof;
Dlow = Profile(row).Dlow;
Dhigh = Profile(row).Dhigh;
if y(1)>y(end)
        x = flip(Profile(row).Xshore);
        y = flip(Profile(row).Prof);
end
Dlow_loc = x(find(y==Dlow));
Dhigh_loc = x(find(y==Dhigh));
bw = Profile(row).BeachW;
zdat_loc = Dlow_loc - bw;
[value1, b_start] = min(abs(x(:)-zdat_loc));
ndx = (x(end) - zdat_loc)/0.5;
ndx_med = (Dhigh_loc - zdat_loc)/0.5;
ndx_xh = (x(end) - zdat_loc)/0.05;
if quality == "high"
    xnew = zeros(1,round(ndx+b_start));
    for i = 1:length(xnew) 
        if i < b_start  
            xnew(i) = x(i);
        else
            xnew(i) = xnew(i-1)+0.5;
        end
    end
ynew = interp1(x,y,xnew);
% figure(1)
% plot(x,y)
% figure(2)
% plot(xnew,ynew)
elseif quality == "extra high"
      xnew = zeros(1,round(ndx_xh+b_start));
    for i = 1:length(xnew) 
        if i < b_start  
            xnew(i) = x(i);
        else
            xnew(i) = xnew(i-1)+0.05;
        end
    end
ynew = interp1(x,y,xnew);
elseif quality == "medium"
    j =1;
    xnew = zeros(1,round(ndx_med+b_start+length(x)-find(y==Dhigh)));
    for i = 1:length(xnew) 
        if i < b_start  
            xnew(i) = x(i);
        elseif i >= b_start && xnew(i-1) < Dhigh_loc
            xnew(i) = xnew(i-1)+0.5;
        else
            xnew(i) = x(find(y==Dhigh)+j);
            j = j+1;
        end
    end
    while xnew(end)< x(end)
        k = find(x == xnew(end));
        xnew = [xnew, x(k+1)];
    end
        
ynew = interp1(x,y,xnew);
% figure(1)
% plot(x,y)
% figure(2)
% plot(xnew,ynew)
end

end
