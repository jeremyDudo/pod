using DifferentialEquations, Plots

m1 = 15;                                # kg (air bearings)
m2 = 130;                               # kg (chassis)
k1 = 500000000;                         # N/m
resolution = 10;                        # mesh size
k2 = linspace(40000,100000,resolution); # N/m
c1 = 0;
c2 = linspace(2000,8000,resolution);    # units
frequency = 33.5;                       # hertz
omega_base = frequency*2*pi;            # rad/s
A = 0.001;                              # Meters
g = 9.81;                               # m/s^2

peak_responses = zeros(length(c2),length(k2));

M = [m1 0;0 m2];
C = [c2 -c2;-c2 c2];
K = [(k1+k2) -k2;-k2 k2];

alg = QNDF();

for i = 1:length(c2)
    for j = 1:length(k2)


        # Running ode45 using the current set of parameters
        [t,y] = ode15s(@(t,s) suspension_ode(t,s,m1,m2,g,k1,k2(i),c1,c2(j),A,omega_base),[0 1.5],[0 0 0 0]);
        peak_responses(i,j) = max(y(:,3));
       
    end
end