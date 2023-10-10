function phase = EATAN_A1(QQ, II)
phase_atan2 = atan2(QQ, II);
phase_dc = Phase_compensation(diff(phase_atan2.'));
phase = cumsum([phase_atan2(1); phase_dc]);

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

