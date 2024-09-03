# Dynamic QSP reporting with Julia

## Preparations

using HetaSimulator
using StatsPlots

## Loading

p = load_platform(".", rm_out = true)
p = load_platform(".")
m = models(p)[:nameless]

## Default simulation

Scenario(m, (0.,30.)) |> sim |> plot
Scenario(m, (0.,30.), parameters = [:IR_total=>55., :GLUT4_total=>50, :diabetes=>0.15]) |> sim |> plot

## Simulation scenarios

scn_csv = read_scenarios("./julia/scenarios.csv")
add_scenarios!(p, scn_csv)
p

p |> sim |> plot

## Advanced visualization

results_df = sim(p) |> DataFrame # simulate all scenarios, then convert them
first(results_df, 7)

#reproducing data from the original study

### Fig5

@df results_df plot(:t, :measuredIRp, group = :scenario, title = "Fig5 1B")
@df results_df plot(:t, :measuredIRint, group = :scenario, title = "Fig5 1C")
# 1D
@df results_df plot(:t, :measuredIRS1p, group = :scenario, title = "Fig5 2B")
@df results_df plot(:t, :measuredIRS1307, group = :scenario, title = "Fig5 2C")
# 2D
@df results_df plot(:t, :measuredPKB308p, group = :scenario, title = "Fig5 3B")
@df results_df plot(:t, :measuredPKB473p, group = :scenario, title = "Fig5 3C")
# 3D
#@df results_df plot(:t, :measuredAS160p, group = :scenario, title = "Fig5 4B")
#@df results_df plot(:t, :measuredmTORC1a, group = :scenario, title = "Fig5 4C")
#@df results_df plot(:t, :measuredS6Kp, group = :scenario, title = "Fig5 4D")
# 5B
#@df results_df plot(:t, :measuredmTORC2a, group = :scenario, title = "Fig5 5C")
#@df results_df plot(:t, :measuredS6p, group = :scenario, title = "Fig5 5D")

### Titration-like simulations

mcvecs1 = DataFrame(
    insulin = [1.00E-3, 1.16E-3, 1.00E-2, 3.16E-2, 1.00E-1, 3.16E-1, 1.00E0, 3.16E0, 1.00E1, 3.16E1, 1.00E2],
    IR_total = 100.,
    GLUT4_total = 100.,
    diabetes = 1.,
    )
mcvecs2 = DataFrame(
    insulin = [1.00E-3, 1.16E-3, 1.00E-2, 3.16E-2, 1.00E-1, 3.16E-1, 1.00E0, 3.16E0, 1.00E1, 3.16E1, 1.00E2],
    IR_total = 55.,
    GLUT4_total = 50.,
    diabetes = 0.15,
    )
mcvecs = vcat(mcvecs1, mcvecs2)

results_titr = mc(p, vcat(mcvecs1, mcvecs2); scenarios = [:titr])
results_titr_df = DataFrame(results_titr; parameters_output = [:insulin, :diabetes])
first(results_titr_df, 7)

@df results_titr_df plot(
    :insulin, :measuredmTORC2a,
    title = "Fig5 1A",
    xlabel="insulin, nM", ylabel="mTORC2a measured",
    group=:diabetes,
    xscale = :log10,
    legend = :topleft
)

## Multiple simulations

results_mc = mc(
    p,
    [
        :k1a => LogNormal(0.6331, 0.5),
        :k1basal => LogNormal(0.03683, 0.5),
        :k1c => LogNormal(0.8768, 0.5),
        :k1d => LogNormal(31.01, 0.5)
    ],
    100,                      # number of 
    scenarios = [:base, :ir], # scenarios names to simulate
    saveat = 0:(0.1):30,      # time points
    abstol = 1e-7
)

plot(results_mc, vars=[:measuredIRp, :measuredIRint])

summary_mc = EnsembleSummary(results_mc; quantiles=[0.05, 0.95])
plot(summary_mc, vars=[:measuredIRp, :measuredIRint]) # to plot all observables