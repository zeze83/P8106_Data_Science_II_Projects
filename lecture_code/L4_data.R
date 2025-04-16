library(RNHANES)

dat <- nhanes_load_data(file_name = "l13_B", year = "2001-2002")

dat = dat %>% 
  left_join(nhanes_load_data("BMX_B", "2001-2002"), by="SEQN") %>%
  left_join(nhanes_load_data("BPX_B", "2001-2002"), by="SEQN") %>%
  left_join(nhanes_load_data("DEMO_B", "2001-2002"), by="SEQN")

dat = dat %>% 
  select(SEQN, RIAGENDR, RIDRETH1, RIDAGEYR, BMXBMI, BPXSY1, LBDHDL) %>%
  mutate(RIAGENDR = as_factor(RIAGENDR), RIDRETH1 = as_factor(RIDRETH1))

colnames(dat) <- c("ID", "gender", "race", "age", "bmi", "sbp", "hdl")

dat <- na.omit(dat)
save(dat, file = "L4_data.RData")