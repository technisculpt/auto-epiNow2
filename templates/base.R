data_file = '{{data_file}}'

#session_lib = 'C:/Users/mlaga/code/nsw-epiNow2/epinow/r_lib'
#.libPaths( c(session_lib, .libPaths()) )
library(EpiNow2)
library(readr)

options(mc.cores = {{cores}})


generation_time <- get_generation_time(disease = "SARS-CoV-2", source = "ganyani")
incubation_period <- get_incubation_period(disease = "SARS-CoV-2", source = "lauer")
# define reporting delay as lognormal with mean of 3 days and sd of 1 day in absence of
# evidence. If data on onset -> report then can use estimate_delay to estimate the delay
reporting_delay <- list(mean = convert_to_logmean(3, 1),
                        mean_sd = 0.1,
                        sd = convert_to_logsd(3, 1),
                        sd_sd = 0.1,
                        max = 15)
                        
# estimate Rt and nowcast/forecast cases by date of infection
# on a 4 core computer this example should take between 4 ~ 30 minutes to run depending on the complexity 
# of the data. For a faster method consider using deconvolution (see ?estimate_infections for details)
# here we use a short cumulative fit to initialise the main model in order to help with convergence
# this may throw some fitting warnings due to its short run time but these should not impact the main fit
out <- epinow(reported_cases = read_csv(data_file), 
              generation_time = generation_time,
              delays = delay_opts(incubation_period, reporting_delay),
              rt = rt_opts(prior = list(mean = 1.5, sd = 0.5)),
              gp = gp_opts(basis_prop = 0.2),
              stan = stan_opts(samples = 2000, chains = {{chains}}, control = list(adapt_delta = 0.95),
                               init_fit = "cumulative"),
              horizon = 14, 
              target_folder = '{{output_folder}}',
              logs = '{{log_file}}',#file.path("logs", "epi", {{log_file}}),
              return_output = TRUE, 
              verbose = TRUE)

# summary of the latest estimates
summary(out)
# plot estimates
plot(out)
# summary of R estimates
summary(out, type = "parameters", params = "R")
