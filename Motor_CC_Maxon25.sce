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
G2 = (Kv/J)/(s + B/J)
FTFW = G1*G2            // Função de Transferência "FeedForward"
FTMA = FTFW*H           // Funcção de Transferência de Malha Aberta
H = Kv
FTMF = FTFW/(FTMA+1)    // Função de Transferência de Malha Fechada
