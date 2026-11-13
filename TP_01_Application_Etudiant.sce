clear;
try
    chdir(get_absolute_file_path("TP_01_Application_Etudiant.sce"));
catch
end
exec("TP_01_Outils_Quadrature.sce", -1);

function y = modele(x)
    y = exp(x);
endfunction

Iref = %e - 1;
ns = [4 8 16 32];
ET = zeros(1, length(ns)); ES = ET;
errT = ET; errS = ET;

mprintf("=== PARTIE 1 : exp(x) sur [0,1], Iref = %.12f ===\n", Iref);
for k = 1:length(ns)
    n = ns(k);
    [t, y] = echantillonner(modele, 0, 1, n);

    ET(k) = trapezes(t, y);
    ES(k) = simpson(t, y);

    errT(k) = abs(ET(k) - Iref);
    errS(k) = abs(ES(k) - Iref);
    mprintf("n=%d T=%.9f S=%.9f ET=%.3e ES=%.3e\n", ..
            n, ET(k), ES(k), errT(k), errS(k));
end

mprintf("\n--- Ordres observes ---\n");
for k = 1:length(ns)-1

    pT = ordre_observe(errT(k), errT(k+1));
    pS = ordre_observe(errS(k), errS(k+1));
    mprintf("n=%d -> %d : pT=%.3f pS=%.3f\n", ..
            ns(k), ns(k+1), pT, pS);
end

tmin = [0 10 20 30 40];
Pkw  = [2.0 2.6 3.0 2.5 1.9];
th = zeros(1, length(tmin));
for i = 1:length(tmin)

    th(i) = tmin(i) / 60;
end

Etrap = trapezes(th, Pkw);
Esimp = simpson(th, Pkw);

mprintf("\n=== PARTIE 2 : pompe ===\n");
mprintf("Pompe : trapezes=%.6f kWh ; Simpson=%.6f kWh\n", Etrap, Esimp);
mprintf("Ecart=%.6f kWh ; borne des lectures=%.6f kWh\n", ..
        abs(Etrap - Esimp), 0.1*40/60);

mprintf("\n=== PARTIE 3 : controles ===\n");
tc = [0 1 2 3 4];
Pc = 10 + 4*tc - tc.^2;
T4c = trapezes(tc, Pc);
S4c = simpson(tc, Pc);
mprintf("T4=%.6f J (attendu 50) ; S4=%.6f J (attendu %.6f)\n", ..
        T4c, S4c, 152/3);
if abs(T4c - 50) < 1e-12 & abs(S4c - 152/3) < 1e-12 then
    mprintf("Controle OK : routines validees.\n");
else
    mprintf("ATTENTION : controle en echec.\n");
end

tirr = [0 1 3 4 6];
Pirr = [1 2 3 4 5];
mprintf("Temps irreguliers : trapezes=%.4f\n", trapezes(tirr, Pirr));
ierr = execstr("simpson(tirr, Pirr)", "errcatch");
if ierr <> 0 then
    mprintf("Simpson refuse bien les pas inegaux : %s\n", lasterror());
else
    mprintf("PROBLEME : Simpson aurait du refuser ces donnees.\n");
end


