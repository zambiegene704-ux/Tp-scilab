function q = trapezes(t, y)
    n = length(t) - 1;
    if n < 1 | length(y) <> length(t) then
        error("Deux vecteurs de meme longueur sont requis.");
    end
    q = 0;
    for i = 1:n
        h = t(i+1) - t(i);
        if h <= 0 then error("Les abscisses doivent croitre."); end
        q = q + h * (y(i) + y(i+1)) / 2;
    end
endfunction

function q = simpson(t, y)
    n = length(t) - 1;
    if n < 2 | length(y) <> length(t) then
        error("Vecteurs incompatibles ou trop courts.");
    end
    if modulo(n, 2) <> 0 then error("Simpson exige n pair."); end
    h = t(2) - t(1);
    for i = 1:n
        pas = t(i+1) - t(i);
        if pas <= 0 then error("Les abscisses doivent croitre."); end
        if abs(pas - h) > 1e-10 * max(1, abs(h)) then
            error("Simpson exige des pas egaux.");
        end
    end
    q = y(1) + y(n+1);
    for i = 2:n
        if modulo(i, 2) == 0 then
            q = q + 4*y(i);
        else
            q = q + 2*y(i);
        end
    end
    q = h*q/3;
endfunction
