library('mrgsolve')

system('heta build --dist-dir . ..', intern = TRUE)

m <- mrgsolve::mread(model = 'nameless', file = '../_mrgsolve/nameless.cpp')

## Default simulation

observables <- '
  measuredIRp,
  measuredIRint,
  measuredIRS1p,
  measuredIRS1307,
  measuredPKB308p,
  measuredPKB473p,
  measuredAS160p,
  measuredmTORC1a,
  measuredS6Kp,
  glucoseuptake,
  measuredmTORC2a,
  measuredS6p
'

m %>% mrgsim(end = 30) %>% plot(observables)

m %>% param(IR_total=55, GLUT4_total=50, diabetes=0.15) %>% mrgsim(end = 30) %>% plot(observables)

