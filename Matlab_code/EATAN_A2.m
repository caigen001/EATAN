function phase = EATAN_A2(QQ, II, k, Fs, ts)
phase_atan2 = atan2(QQ, II);
pEATAN = zeros(1, Fs*ts);
phase_dc = Phase_compensation(diff(phase_atan2.', k-1));
pEATAN(k:end) = phase_dc.';

t=1/Fs:1/Fs:ts;

for index =  k:-1:2
    pEATAN(index:end) =  pEATAN(index:end) - mean(pEATAN(index:end));
    pEATAN(index-1:end) = cumsum(pEATAN(index-1:end));
    tt=polyfit(t(index-1:end),pEATAN(index-1:end),k+1-index);
    pEATAN(index-1:end) = pEATAN(index-1:end) - polyval(tt,t(index-1:end));  
end
pEATAN = pEATAN - mean(pEATAN);
tt=polyfit(t,pEATAN,k);
phase = pEATAN - polyval(tt,t); 

%%%%%%%%% Phase_compensation Functions  %%%%%%%%%
function phase = Phase_compensation(phase)
len = length(phase);

diff_p = diff(phase);            

diff_num = diff_p./(2*pi);

roundDown = abs(rem(diff_num, 1)) <= 0.5;

diff_num(roundDown) = fix(diff_num(roundDown));

diff_num = round(diff_num);

diff_num(abs(diff_p) < pi) = 0;

phase(2:len,:) = phase(2:len,:) - (2*pi)*cumsum(diff_num,1);

