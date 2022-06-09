function a = ID2row(ID)

current_folder = pwd;
cd('C:\Users\rf20354\Documents\Research\RC_Profiles')
load('Final_TWL_Profiles_04282022.mat');
cd(current_folder)

ID_array = zeros(length(Profile),1);
for i = 1: length(Profile)
    ID_array(i) = Profile(i).ID;
end

a = find(ID_array == ID);
end
