# Dynamic QSP reporting with Julia

## Preparations

using HetaSimulator, StatsPlots

## Loading

p = load_platform(".", rm_out = true)
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

scn_titr_csv = read_scenarios("./julia/titration.csv")
add_scenarios!(p, scn_titr_csv)

results_titr = sim(p, saveat=[10.]);
results_titr_df = DataFrame(results_titr, add_parameters=true);
results_titr_subset = subset(results_titr_df, :is_titr=>x->x.===1.);
first(results_titr_subset, 7)

@df results_titr_subset plot(
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

summary_mc = EnsembleSummary(results_mc; quantiles=[0.05,0.95])
plot(summary_mc, idxs=[1,2]) # to plot observables 1 - IRp, 2 - IRint
