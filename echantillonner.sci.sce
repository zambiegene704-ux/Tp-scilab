function [t, y] = echantillonner(f, a, b, n)
    if n < 1 | b <= a then error("Intervalle ou maillage incorrect."); end
    t = zeros(1, n+1);
    y = zeros(1, n+1);
    for i = 1:n+1
        t(i) = a + (i-1)*(b-a)/n;
        y(i) = f(t(i));
    end
endfunction

function p = ordre_observe(E_n, E_2n)
    if E_n <= 0 | E_2n <= 0 then
        p = %nan;
    else
        p = log(E_n/E_2n)/log(2);
    end
endfunction
