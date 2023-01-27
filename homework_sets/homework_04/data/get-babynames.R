library(tidyverse)
library(here)
library(babynames)

# export babynames data as a CSV file
write_csv(x = babynames, file = here("hw04", "data", "babynames.csv"))
write_csv(x = applicants, file = here("hw04", "data", "applicants.csv"))
write_csv(x = lifetables, file = here("hw04", "data", "lifetables.csv"))
write_csv(x = births, file = here("hw04", "data", "births.csv"))

write_csv(x = babynames, file = here("hw04", "app1", "data", "babynames.csv"))
write_csv(x = applicants, file = here("hw04", "app1", "data", "applicants.csv"))
write_csv(x = lifetables, file = here("hw04", "app1", "data", "lifetables.csv"))
write_csv(x = births, file = here("hw04", "app1", "data", "births.csv"))

write_csv(x = babynames, file = here("hw04", "app2", "data", "babynames.csv"))
write_csv(x = applicants, file = here("hw04", "app2", "data", "applicants.csv"))
write_csv(x = lifetables, file = here("hw04", "app2", "data", "lifetables.csv"))
write_csv(x = births, file = here("hw04", "app2", "data", "births.csv"))

