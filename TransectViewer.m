close all
clear
clc
current_folder = pwd;
cd('C:\Users\rf20354\Documents\Research\RC_Profiles')
a = load('Final_TWL_Profiles_04282022RMSE.mat');
cd(current_folder)
lats = [a.Profile(:).lat]; lons = [a.Profile(:).lon];
latNaN = [];
lat1 = [];
lat2 = [];
lat3 = [];
lat4 = [];
lat5 = [];
lonNaN = [];
lon1 = [];
lon2 = [];
lon3 = [];
lon4 = [];
lon5 = [];
for i = 1:length(a.Profile)
    if isnan(a.Profile(i).RMSE == 1)
        latNaN = [latNaN,a.Profile(i).lat];
        lonNaN = [lonNaN,a.Profile(i).lon];
    elseif a.Profile(i).RMSE < 0.2
        lat1 = [lat1,a.Profile(i).lat];
        lon1 = [lon1,a.Profile(i).lon];
    elseif a.Profile(i).RMSE < 0.4 && a.Profile(i).RMSE >= 0.2
        lat2 = [lat2,a.Profile(i).lat];
        lon2 = [lon2,a.Profile(i).lon];
    elseif a.Profile(i).RMSE < 0.6 && a.Profile(i).RMSE >= 0.4
        lat3 = [lat3,a.Profile(i).lat];
        lon3 = [lon3,a.Profile(i).lon];
    elseif a.Profile(i).RMSE < 0.8 && a.Profile(i).RMSE >= 0.6
        lat4 = [lat4,a.Profile(i).lat];
        lon4 = [lon4,a.Profile(i).lon];
    elseif a.Profile(i).RMSE > 0.8
        lat5 = [lat5,a.Profile(i).lat];
        lon5 = [lon5,a.Profile(i).lon];
    end
end
pushbuttonPlot2(lats,lons,a,lat1,lat2,lat3,lat4,lat5,lon1,lon2,lon3,lon4,lon5,latNaN,lonNaN)

function pushbuttonPlot2(lats,lons,a,lat1,lat2,lat3,lat4,lat5,lon1,lon2,lon3,lon4,lon5,latNaN,lonNaN)
% myfig = uifigure('Name','Transect Viewer','WindowStyle','alwaysontop');
% myfig.Position = get(0, 'Screensize');
% myfig = uifigure('Windowstyle','alwaysontop','Position', get(0, 'Screensize'));
% g = uigridlayout(myfig,[2,1]);
% ax1 = geoaxes(g);
% ax2 = uiaxes(g);
myfig = figure(1);
subplot(2,1,1)
% geoplot(lats,lons,'*','color','r','MarkerSize',4);
geoplot(lat1,lon1,'.','color','#77AC30','MarkerSize',15);
hold on
geoplot(lat2,lon2,'.','color','#4DBEEE','MarkerSize',15);
hold on
geoplot(lat3,lon3,'.','color','#EDB120','MarkerSize',15);
hold on 
geoplot(lat4,lon4,'.','color','#D95319','MarkerSize',15);
hold on
geoplot(lat5,lon5,'.','color','#A2142F','MarkerSize',15);
hold on
geoplot(latNaN,lonNaN,'.','color','k','MarkerSize',15);
legend('RMSE < 0.2','0.2 < RMSE <0.4','0.4 < RMSE <0.6','0.6 < RMSE <0.8','RMSE > 0.8','NaN')
% set(gcf, 'Position', get(0, 'Screensize'));
myfig.Position = [100 100 900 900];
geobasemap('topographic');
c = uicontrol(myfig,'Style','radiobutton');
c.Position = [20 450 120 50];
c.String = 'Grab Transect';
% % c = uibutton(myfig,'state','ButtonPushedFcn', @(c,event) plotButtonPushed(src,event));
% bg = uibuttongroup(myfig,'Position',[20 530 120 50]);   
% c1 = uiradiobutton(bg,'Position',[5 5 130 15]);
% c1.Text = 'Pan/Zoom Mode';
% c2 = uiradiobutton(bg,'Position',[5 25 130 15]);
% c2.Text = 'Selection Mode';
% bg.SelectionChangedFcn = {@plotButtonPushed};
c.Callback = @plotButtonPushed;
    
    function plotButtonPushed(src,event)
        if c.Value == true
            disp('hi')
            % Initialize data cursor object
                cursorobj = datacursormode(myfig);
                cursorobj.SnapToDataVertex = 'on'; % Snap to our plotted data, on by default
                
                while ~waitforbuttonpress 
                    % waitforbuttonpress returns 0 with click, 1 with key press
                    % Does not trigger on ctrl, shift, alt, caps lock, num lock, or scroll lock
                    cursorobj.Enable = 'on'; % Turn on the data cursor, hold alt to select multiple points
                end




                cursorobj.Enable = 'off';

                mypoints = getCursorInfo(cursorobj);
                pt = mypoints.Position;
              
                 subplot(2,1,2);
                cla()
         myfig.Position = [100 100 900 900];
                for i=1:length(lats)
                    if pt(1) == lats(i) && pt(2) == lons(i)
                        zdat = a.Profile(i).zdatum;
                        Dlow = a.Profile(i).Dlow;
                        lat = a.Profile(i).lat; lon = a.Profile(i).lon;
                        ID = row2ID(i);
                        x = a.Profile(i).Xshore;
                        y = a.Profile(i).Prof;
                        if y(1)>y(end)
                            x = flip(a.Profile(i).Xshore);
                            y = flip(a.Profile(i).Prof);
                        end
                       nx = (abs(x(end) - x(1)))/0.05+1;
                        xnew = linspace(x(1),x(end),nx);
                        ynew = interp1(x,y,xnew);
                        j = 0;

                            for m = 1:length(xnew)
                                if ynew(m)>zdat && j == 0
                                    diff1 = abs(ynew(m-1)-zdat);
                                    diff2 = abs(ynew(m)-zdat);
                                    if diff1<diff2
                                        zdat2 = ynew(m-1);
                                        zdat_loc = xnew(m-1);
                                        zdat_i = m;
                                        j = 1;

                                    else
                                        zdat2 = ynew(m);
                                        zdat_loc = xnew(m);
                                        zdat_i = m;
                                        j = 1;

                                    end
                                elseif j ==1 && ynew(m)>Dlow
                                    diff1 = abs(ynew(m-1)-Dlow);
                                    diff2 = abs(ynew(m)-Dlow);
                                    if diff1<diff2
                                        Dlow2 = ynew(m-1);
                                        Dlow_loc = xnew(m-1);
                                        Dlow_i = m;
                                       break      
                                    else
                                        Dlow2 = ynew(m);
                                        Dlow_loc = xnew(m);
                                        Dlow_i = m;
                                        break       
                                    end
                                end
                            end



                        slope = a.Profile(i).BeachSlope;

                        y3 = ynew(zdat_i:Dlow_i);
                        x3 = xnew(zdat_i:Dlow_i);
                      
                        y2 = linspace(zdat,Dlow,length(x3));
              
                        rmse = rms(y2-y3);


                        
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

                        c.Value = false;
                       end
                end


        else
            datacursormode off
        end
    end

end


