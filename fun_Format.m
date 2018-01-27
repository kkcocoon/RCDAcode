function [sfrate] = fun_Format(srate)

sfrate = '';
for i=1:size(srate,1)
    sfratej = '';
    for j=1:size(srate,2)
        rate = srate(i,j);
        frate = num2str(eval(vpa(rate,4)));
        if length(frate)==4
            frate = [frate, '0'];
        elseif length(frate)==3
            if rate==100
                frate = '100.0';
            else
                frate = [frate, '00'];
            end
        elseif length(frate)==2
            frate = [frate, '.00'];
        elseif length(frate)==1
            frate = ['0' frate, '.00'];
        end
        sfratej = [sfratej, frate,'  '];
    end
    sfrate = [sfrate; sfratej];
end