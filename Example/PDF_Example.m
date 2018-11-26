id = labindex;
fid = fopen(['input' '1' '.txt']);
A = textscan(fid,'%q');
numtimes = sum(ismember(A{1},'eeyad7'));
totaltimes = numtimes;
fprintf('Total number of occurences: %d\n', totaltimes);