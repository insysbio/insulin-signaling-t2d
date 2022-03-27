## Preamble

# install.packages('mrgsolve')
# install.packages('ggplot2')

## Loading platform

library('mrgsolve')
library('ggplot2')

system('heta build --dist-dir . ..', intern = TRUE)

m <- mrgsolve::mread(model = 'nameless', file = '../_mrgsolve/nameless.cpp')

observables <- paste(
  'measuredIRp',
  'measuredIRint',
  'measuredIRS1p',
  'measuredIRS1307',
  'measuredPKB308p',
  'measuredPKB473p',
  'measuredAS160p',
  'measuredmTORC1a',
  'measuredS6Kp',
  'glucoseuptake',
  'measuredmTORC2a',
  'measuredS6p',
  sep=', '
)

## Default simulation

m %>% mrgsim(end = 30, outvars = observables) %>% plot

m %>% param(IR_total=55, GLUT4_total=50, diabetes=0.15) %>% mrgsim(end = 30, outvars = observables) %>% plot

## Simulation scenarios

scn_base <- m %>% update(end = 30, outvars = observables)
scn_ir <- m %>% param(IR_total=55, GLUT4_total=50, diabetes=0.15) %>% update(end = 30, outvars = observables)

## Advanced visualization

results_df_base <- mrgsim(scn_base) %>% as.data.frame
results_df_ir <- mrgsim(scn_ir) %>% as.data.frame

results_df_base$scenario <- 'base'
results_df_ir$scenario <- 'ir'
results_df <- rbind(results_df_base, results_df_ir)

knitr::kable(head(results_df), format="html")

ggplot(results_df, aes(x=time, y=measuredIRp)) +
  geom_line(aes(col=scenario)) +
  labs(title="Fig5 1B")

ggplot(results_df, aes(x=time, y=measuredIRint)) +
  geom_line(aes(col=scenario)) +
  labs(title="Fig5 1C")

ggplot(results_df, aes(x=time, y=measuredIRS1p)) +
  geom_line(aes(col=scenario)) +
  labs(title="Fig5 2B")

ggplot(results_df, aes(x=time, y=measuredIRS1p)) +
  geom_line(aes(col=scenario)) +
  labs(title="Fig5 2C")

ggplot(results_df, aes(x=time, y=measuredPKB308p)) +
  geom_line(aes(col=scenario)) +
  labs(title="Fig5 3B")

ggplot(results_df, aes(x=time, y=measuredPKB473p)) +
  geom_line(aes(col=scenario)) +
  labs(title="Fig5 3C")

## Titration-like simulations

titr_scn_df <- data.frame(ID = 1:22, insulin=c(
  1.00E-03,
  3.16E-03,
  1.00E-02,
  3.16E-02,
  1.00E-01,
  3.16E-01,
  1.00E+00,
  3.16E+00,
  1.00E+01,
  3.16E+01,
  1.00E+02,
  1.00E-03,
  3.16E-03,
  1.00E-02,
  3.16E-02,
  1.00E-01,
  3.16E-01,
  1.00E+00,
  3.16E+00,
  1.00E+01,
  3.16E+01,
  1.00E+02
))

results_titr_base <- scn_base %>%
  idata_set(titr_scn_df) %>%
  mrgsim(end = 10) %>%
  filter(time == 10)
results_titr_ir <- scn_ir %>%
  idata_set(titr_scn_df) %>%
  mrgsim(end = 10) %>%
  filter(time == 10)

results_titr_base$scenario <- 'base'
results_titr_ir$scenario <- 'ir'
results_titr <- rbind(results_titr_base, results_titr_ir)

results_titr$insulin <- titr_scn_df$insulin[match(results_titr$ID, titr_scn_df$ID)]

ggplot(results_titr, aes(x=insulin, y=measuredmTORC2a)) +
  geom_line(aes(col=scenario)) +
  scale_x_log10() +
  labs(title="Fig5 1A")

## Multiple simulations

mc_scn_df <- data.frame(
  ID = 1:100,
  k1a = rlnorm(100, mean=0.6331, sd=0.5),
  k1basal = rlnorm(100, mean=0.03683, sd=0.5),
  k1c = rlnorm(100, mean=0.8768, sd=0.5),
  k1d = rlnorm(100, mean=31.01, sd=0.5)
)

results_mc_base <- scn_base %>%
  idata_set(mc_scn_df) %>%
  mrgsim(outvars='measuredIRp, measuredIRint')
results_mc_ir <- scn_ir %>%
  idata_set(mc_scn_df) %>%
  mrgsim(outvars='measuredIRp, measuredIRint')

results_mc_base %>% plot
results_mc_ir %>% plot
