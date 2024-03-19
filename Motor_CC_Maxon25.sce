// Controle de Motor CC - Maxon RE 25 118743 (10W) @ https://www.maxongroup.com/medias/sys_master/root/8992313966622/EN-22-152.pdf
//== Dados do Motor ==\\
Nom_Vol = 12        // Tensão Nominal
Vel_Vaz = 4850      // Velocidade à vazio em rpm
Cor_Vaz = 26.3e-3   // Corrente à vazio
Cor_Sta = 5.5       // Corrente p/ motor parado
Kv = 406            // Constante de velocidade em rmp/V
Kt = 23.5e-3        // Constante de torque
tau_m = 4.25e-3     // Constante de tempo mecânica (J/B) => Perguntar
La = 0.238e-3       // Indutância nos Terminais
J = 10.8            // Inércia do motor em g*cm^2 (SI é kg*m^2)
// Atualizar valores (rmp -> rad/s)
rpm2rads = %pi/30 // Fator de conversão rpm -> rad/s
Vel_Vaz = Vel_Vaz*rpm2rads
Kv = 1/(Kv * rpm2rads) // Converte para V/(rad/s)
J = (J/1e3)/1e4
// Valor para os blocos
Ra = Nom_Vol/Cor_Sta    // Resistência de Armadura
B = Kt*Cor_Vaz/Vel_Vaz  // Inércia do Motor
// Monta o Sistema (VEL_ANG/Vi)
s = %s
G1 = (1/La)/(s + Ra/La)
G1 = syslin('c', G1)
G2 = (Kv/J)/(s + B/J)
G2 = syslin('c', G2)
FTFW = G1*G2            // Função de Transferência "FeedForward"
H = Kv                  // Malha de Realimentação
H = syslin('c', H, 1)
FTMA = FTFW*H           // Função de Transferência de Malha Aberta
FTMF = FTFW/.H          // Função de Transferência de Malha Fechada
tmax = 30e-3
t = [0:tmax/1e3:tmax]'
step = 12*csim('step', t, FTMF)
disp("==========")
disp("=== G1 ===")
disp(G1)
disp("=== G2 ===")
disp(G2)
disp("=== H  ===")
disp(H)
disp("=== MF ===")
disp(FTMF)
disp("==========")
// Assumindo La -> 0
G1 = 1/Ra
G1 = syslin('c', G1, 1)
G2 = (Kv/J)/(s + B/J)
G2 = syslin('c', G2)
FTFW = G1*G2            // Função de Transferência "FeedForward"
H = Kv                  // Malha de Realimentação
H = syslin('c', H, 1)
FTMA = FTFW*H           // Função de Transferência de Malha Aberta
FTMF = FTFW/.H          // Função de Transferência de Malha Fechada
disp("==========")
disp("=== G1 ===")
disp(G1)
disp("=== G2 ===")
disp(G2)
disp("=== H  ===")
disp(H)
disp("=== MF ===")
disp(FTMF)
disp("==========")
// Simula o Sistema
step_app = 12*csim('step', t, FTMF)         // Valor aproximado
plot2d(1e3*t, [step' step_app'], [1, 2])    // Plota a função de transferência em t
xgrid(35)
xtitle("Resposta ao degrau (12 V)", "tempo [ms]", "Velocidade [rad/s]")
legend("Aproximado", "Real", 2)
