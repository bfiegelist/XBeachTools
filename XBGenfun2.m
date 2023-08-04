function XBGenfun2(ID, Ho, T,MWD,wavemodel,quality)

  %  load  ../Final_TWL_Profiles_03222022.mat;
    current_folder = pwd;
    cd('C:\Users\rf20354\Documents\Research\RC_Profiles')
    load('Final_TWL_Profiles_04282022.mat');
    cd(current_folder)
    prof = ID2row(ID);

    c = 9.81*T/(2*pi);
    lengthprof = round(abs(Profile(prof).Xshore(1)-Profile(prof).Xshore(end)));
    %duration = round(2*(lengthprof/c + 1000));
    duration = 1800;
%     if Profile(prof).Xshore(1)==0
%         [xgr zgr] = xb_grid_xgrid((Profile(prof).Xshore), (Profile(prof).Prof));
%     else
%         [xgr zgr] = xb_grid_xgrid(flip(Profile(prof).Xshore), flip(Profile(prof).Prof));
%     end
if convertCharsToStrings(wavemodel) == "surfbeat"
    if quality == "high" | quality == "medium"
        [xgr, zgr] = RefineTransect(ID, quality);

        xbi = xb_generate_model( ...
                 'bathy',   { 'x', xgr, 'z', zgr},...
                 'waves',   { 'Hm0', Ho, 'Tp', T,'duration',duration,'mainang',MWD}, ...
                 'settings', {'morphology', 0, 'sedtrans', 0, 'wavemodel','surfbeat','snells', 0, 'tstop', duration,...
                 'zs0',Profile(prof).zdatum,'nx',length(xgr)-1, 'nglobalvar', {'H' 'zb' 'zs'},...
                 'npoints',{'0 0'}, 'npointvar', {'zb','zs','H'}, 'nrugauge', {'0 0'}});
             xbi.data(7).value.data.value = xgr;
             xbi.data(8).value.data.value = zeros(1,length(xgr));
             xbi.data(9).value.data.value = zgr;

               xb_write_input('params.txt', xbi);

        load('x.grd')
        point = [num2str(x(1)),' 0'];
        xbi = xb_generate_model( ...
                 'bathy',   { 'x',xgr, 'z', zgr,'xgrid', {'vardx', 1}},...
                 'waves',   { 'Hm0', Ho, 'Tp', T,'duration',duration,'mainang',MWD}, ...
                 'settings', {'morphology', 0, 'sedtrans', 0, 'wavemodel',wavemodel,'snells', 0, 'tstop', duration,...
                  'zs0',Profile(prof).zdatum,'nx',length(xgr)-1, 'nglobalvar', {'H' 'zb' 'zs'},...
                 'npoints',{point}, 'npointvar', {'zb','zs','H'}, 'nrugauge', {point}});
             xbi.data(7).value.data.value = xgr;
             xbi.data(8).value.data.value = zeros(1,length(xgr));
             xbi.data(9).value.data.value = zgr;
        xb_write_input('params.txt', xbi);
    elseif quality == "low"
        if Profile(prof).Xshore(1)==0
          [xgr zgr] = xb_grid_xgrid((Profile(prof).Xshore), (Profile(prof).Prof));
        else
          [xgr zgr] = xb_grid_xgrid(flip(Profile(prof).Xshore), flip(Profile(prof).Prof));
        end
        xbi = xb_generate_model( ...
                 'bathy',   { 'x', xgr, 'z', zgr},...
                 'waves',   { 'Hm0', Ho, 'Tp', T,'duration',duration,'mainang',MWD}, ...
                 'settings', {'morphology', 0, 'sedtrans', 0, 'wavemodel','surfbeat','snells', 0, 'tstop', duration,...
                 'zs0',Profile(prof).zdatum, 'nglobalvar', {'H' 'zb' 'zs'},...
                 'npoints',{'0 0'}, 'npointvar', {'zb','zs','H'}, 'nrugauge', {'0 0'}});
            
               xb_write_input('params.txt', xbi);

        load('x.grd')
        point = [num2str(x(1)),' 0'];
        xbi = xb_generate_model( ...
                 'bathy',   { 'x',xgr, 'z', zgr,'xgrid', {'vardx', 1}},...
                 'waves',   { 'Hm0', Ho, 'Tp', T,'duration',duration,'mainang',MWD}, ...
                 'settings', {'morphology', 0, 'sedtrans', 0, 'wavemodel',wavemodel,'snells', 0, 'tstop', duration,...
                  'zs0',Profile(prof).zdatum, 'nglobalvar', {'H' 'zb' 'zs'},...
                 'npoints',{point}, 'npointvar', {'zb','zs','H'}, 'nrugauge', {point}});
           
        xb_write_input('params.txt', xbi);
    
    else
        if Profile(prof).Xshore(1)==0
          xgr = Profile(prof).Xshore;
          zgr = Profile(prof).Prof;
         else
          xgr = flip(Profile(prof).Xshore);
          zgr = flip(Profile(prof).Prof);
        end
        xbi = xb_generate_model( ...
                 'bathy',   { 'x', xgr, 'z', zgr},...
                 'waves',   { 'Hm0', Ho, 'Tp', T,'duration',duration}, ...
                 'settings', {'morphology', 0, 'sedtrans', 0, 'wavemodel','surfbeat','snells', 0, 'tstop', duration,...
                 'zs0',Profile(prof).zdatum,'nx',length(xgr)-1,  'nglobalvar', {'H' 'zb' 'zs'},...
                 'npoints',{'0 0'}, 'npointvar', {'zb','zs','H'}, 'nrugauge', {'0 0'}});
         xbi.data(7).value.data.value = xgr;
         xbi.data(8).value.data.value = zeros(1,length(xgr));
         xbi.data(9).value.data.value = zgr;   
         xb_write_input('params.txt', xbi);

        load('x.grd')
        point = [num2str(x(1)),' 0'];
        xbi = xb_generate_model( ...
                 'bathy',   { 'x',xgr, 'z', zgr,'xgrid', {'vardx', 1}},...
                 'waves',   { 'Hm0', Ho, 'Tp', T,'duration',duration}, ...
                 'settings', {'morphology', 0, 'sedtrans', 0, 'wavemodel',wavemodel,'snells', 0, 'tstop', duration,...
                  'zs0',Profile(prof).zdatum,'nx',length(xgr)-1,  'nglobalvar', {'H' 'zb' 'zs'},...
                 'npoints',{point}, 'npointvar', {'zb','zs','H'}, 'nrugauge', {point}});
         xbi.data(7).value.data.value = xgr;
         xbi.data(8).value.data.value = zeros(1,length(xgr));
         xbi.data(9).value.data.value = zgr;   
        xb_write_input('params.txt', xbi);
    end
else 
%         if Profile(prof).Xshore(1)==0
%             [nhxgrd nhzgrd] = xb_grid_xgrid((Profile(prof).Xshore), (Profile(prof).Prof),'dxmax',0.5,'dxmin',0.1);
%         else
%             [nhxgrd nhzgrd] = xb_grid_xgrid(flip(Profile(prof).Xshore), flip(Profile(prof).Prof),'dxmax',0.5,'dxmin',0.1);
%         end
        [nhxgrd, nhzgrd] = NonhGrid(ID,T);
         xbi = xb_generate_model( ...
                 'bathy',   { 'x', nhxgrd, 'z', nhzgrd},...
                 'waves',   { 'Hm0', Ho, 'Tp', T,'duration',duration}, ...
                 'settings', {'morphology', 0, 'sedtrans', 0, 'wavemodel','surfbeat','snells', 0, 'tstop', duration,...
                 'zs0',Profile(prof).zdatum,'nx',length(nhxgrd)-1,  'nglobalvar', {'H' 'zb' 'zs'},...
                 'npoints',{'0 0'}, 'npointvar', {'zb','zs','H'}, 'nrugauge', {'0 0'}});
         xbi.data(7).value.data.value = nhxgrd;
         xbi.data(8).value.data.value = zeros(1,length(nhxgrd));
         xbi.data(9).value.data.value = nhzgrd;   
         xb_write_input('params.txt', xbi);

        load('x.grd');
        point = [num2str(x(1)),' 0'];
        xbi = xb_generate_model( ...
                 'bathy',   { 'x',nhxgrd, 'z', nhzgrd,'xgrid', {'vardx', 1}},...
                 'waves',   { 'Hm0', Ho, 'Tp', T,'duration',duration}, ...
                 'settings', {'morphology', 0, 'sedtrans', 0, 'wavemodel',wavemodel,'snells', 0, 'tstop', duration,...
                 'zs0',Profile(prof).zdatum,'nx',length(nhxgrd)-1,  'nglobalvar', {'H' 'zb' 'zs'},...
                 'npoints',{point}, 'npointvar', {'zb','zs','H'}, 'nrugauge', {point}});
         xbi.data(7).value.data.value = nhxgrd;
         xbi.data(8).value.data.value = zeros(1,length(nhxgrd));
         xbi.data(9).value.data.value = nhzgrd;   
        xb_write_input('params.txt', xbi);
end
%     system('C:\Users\rf20354\Documents\xbeach_5849_win32_netcdf\xbeach.exe')
%     Runup_1Dfun('xboutput.nc',Ho,T,ID)
end 