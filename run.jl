using HetaSimulator
using Plots

p = load_platform(".")
m = models(p)[:nameless]

obs = [
    :measuredIRp,     # 1b
    :measuredIRint,   # 1c
    :measuredIRS1p,   # 1d # 2b
    :measuredIRS1307, # 2c # 2d
    :measuredPKB308p, # 3b
    :measuredPKB473p, # 3c # 3d
    :measuredAS160p,  # 4b
    :measuredmTORC1a, # 4c
    :measuredS6Kp,    # 4d
    :glucoseuptake,   # 5b
    :measuredmTORC2a, # 5c
    :measuredS6p,     # 5d
]

scn_base = Scenario(m, (0.,30.))
scn_ir = Scenario(m, (0.,30.), parameters = [:IR_total=>55., :GLUT4_total=>50, :diabetes=>0.15])
res_base = scn_base |> sim
res_ir = scn_ir |> sim

## for fig 5
plot(res_base, vars = [:measuredIRp])     # 1b
plot(res_ir, vars = [:measuredIRp])     # 1b
plot(res_base, vars = [:measuredIRint])   # 1c
plot(res_ir, vars = [:measuredIRint])   # 1c
# 1d
plot(res_base, vars = [:measuredIRS1p])   # 2b
plot(res_base, vars = [:measuredIRS1307]) # 2c
# 2d
plot(res_base, vars = [:measuredPKB308p]) # 3b
plot(res_base, vars = [:measuredPKB473p]) # 3c
# 3d
plot(res_base, vars = [:measuredAS160p])  # 4b
plot(res_base, vars = [:measuredmTORC1a]) # 4c
plot(res_base, vars = [:measuredS6Kp])    # 4d
# 5b
plot(res_base, vars = [:measuredmTORC2a]) # 5c
plot(res_base, vars = [:measuredS6p])     # 5d
