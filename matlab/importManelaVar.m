function var = importManelaVar(filename)
%function var = importManelaVar(filename)

disp 'Loading ';

rawdata = load(filename);

var = zeros(85,217,229);

for k = 1:85
    var(k,:,:) = rawdata( 217*(k-1)+1:217*k,:);
end

disp 'done'
disp ' '
