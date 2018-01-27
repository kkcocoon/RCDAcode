function [frate] = func_format(rate)

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
