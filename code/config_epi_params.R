# Generation time and incubation period distributions used in the real-world 
# application to COVID-19 in Switzerland

variants_timeline <- tribble()

{
  # Incubation period
  maxInc <- 21
  inc_wildtype <- get_discrete_gamma(
    gamma_mean = 5.3, gamma_sd = 3.2, maxX = maxInc, print_params = F
  ) # equals shape = 2.74 and scale = 1.93
  inc_alpha <- get_discrete_gamma(
    gamma_shape = 3.08, gamma_scale = 1.58, maxX = maxInc, print_params = F
  )
  inc_delta <- get_discrete_gamma(
    gamma_shape = 4.43, gamma_scale = 1.01, maxX = maxInc, print_params = F
  )
  inc_omicron <- get_discrete_gamma(
    gamma_shape = 8.5, gamma_scale = 0.41, maxX = maxInc, print_params = F
  )

  # Intrinsic generation time
  # maxGen <- 14
  # gen_wildtype <- get_discrete_gamma(
  #   gamma_mean = 4.2, gamma_sd = 4.9, maxX = maxGen, include_zero = F
  # ) # Hart et al. elife 2021
  # gen_alpha <- get_discrete_gamma(
  #   gamma_mean = 5.5, gamma_sd = 4.0, maxX = maxGen, include_zero = F
  # ) # Hart et al. Lancet Inf. Dis.
  # gen_delta <- get_discrete_gamma(
  #   gamma_mean = 4.7, gamma_sd = 3.3, maxX = maxGen, include_zero = F
  # ) # Hart et al. Lancet Inf. Dis.
  # gen_omicron... not available?

  # Household generation time
  maxGen <- 21
  gen_wildtype <- get_discrete_gamma(
    gamma_mean = 4.9, gamma_sd = 4.1, maxX = maxGen, include_zero = F,
    print_params = F
  ) # Hart et al. elife 2021
  gen_alpha <- get_discrete_gamma(
    gamma_mean = 4.5, gamma_sd = 3.4, maxX = maxGen, include_zero = F,
    print_params = F
  ) # Hart et al. Lancet Inf. Dis.
  gen_delta <- get_discrete_gamma(
    gamma_mean = 3.2, gamma_sd = 2.5, maxX = maxGen, include_zero = F,
    print_params = F
  ) # Hart et al. Lancet Inf. Dis.
  gen_omicron <- get_discrete_lognormal(
    meanlog = 0.98, sdlog = 0.47, maxX = maxGen, include_zero = F,
    print_params = F
  ) # Park et al.

  # Start time series at Jan 01, 2020
  variants_timeline <- tribble(
    ~changepoints, ~pmf_list_inc, ~pmf_list_gen,
    "2020-01-01", inc_wildtype, gen_wildtype,
    "2020-12-21", inc_wildtype, gen_wildtype, # alpha arrives
    "2021-03-29", inc_alpha, gen_alpha, # alpha has taken over completely
    "2021-05-24", inc_alpha, gen_alpha, # delta arrives
    "2021-08-16", inc_delta, gen_delta, # delta has taken over completely
    "2021-12-06", inc_delta, gen_delta, # omicron arrives
    "2022-01-31", inc_omicron, gen_omicron, # omciron has taken over completely
    "2022-12-31", inc_omicron, gen_omicron, # end of time series
  ) %>% mutate(changepoints = as.Date(changepoints) - as.Date("2020-01-01") + 1)
}

# Incubation period
latent_delay_dist_all <- get_distribution_time_series(
  tribble_format = variants_timeline %>% mutate(pmf_list = pmf_list_inc),
  shape = "logistic"
)
latent_delay_dist_all_list <- lapply(
  seq_len(nrow(latent_delay_dist_all)),
  function(i) latent_delay_dist_all[i, ]
)
names(latent_delay_dist_all_list) <- seq_len(nrow(latent_delay_dist_all)) +
  as.Date("2020-01-01") - 1

# Generation interval
generation_time_dist_all <- get_distribution_time_series(
  tribble_format = variants_timeline %>% mutate(pmf_list = pmf_list_gen),
  shape = "logistic"
)
generation_time_dist_all_list <- lapply(
  seq_len(nrow(generation_time_dist_all)),
  function(i) generation_time_dist_all[i, ]
)
names(generation_time_dist_all_list) <- seq_len(nrow(generation_time_dist_all)) +
  as.Date("2020-01-01") - 1
