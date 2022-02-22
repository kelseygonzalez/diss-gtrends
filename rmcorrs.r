#rmcorr script
library(tidyverse)
library(glue)
library(rmcorr)

covid <- read_rds('data/covid.rds')
# suicide <- read_rds(here('data', 'cleaned_data', 'suicide.rds'))

vars <- c('covid_19', 'smell_loss', 'taste_loss')

for (i in vars){
  corr_result <-  rmcorr::rmcorr(fips, measure1 = covid_rate, measure2 = covid_19, dataset = covid)
  covid_mcor[i] <- corr_result
  write_rds(corr_result, glue('data/covid_mcor_{i}.rds'))
}


covid_corrs <- tribble(
  ~'measure', ~'covid_19', ~'smell_loss', ~'taste_loss', 
  'covid_rate, raw corr',
  cor(covid_dat$covid_rate, covid_dat$covid_19),
  cor(covid_dat$covid_rate, covid_dat$smell_loss),
  cor(covid_dat$covid_rate, covid_dat$taste_loss),
  
  'covid_rate, rmcorr',
  glue("{round(covid_mcor$covid_19$r,3)}{stars(covid_mcor$covid_19$p)}"),
  glue("{round(covid_mcor$smell_loss$r,3)}{stars(covid_mcor$smell_loss$p)}"),
  glue("{round(covid_mcor$taste_loss$r,3)}{stars(covid_mcor$taste_loss$p)}")
)

write_rds(covid_corrs, here('data/covid_corrs.rds'))
