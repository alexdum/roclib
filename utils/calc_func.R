# calculeaza si sintezele medii, mulitanuale
change_scen <- function (input, param, hist_per, scen_per ) {
  #bind_rows(input, .id = 'name') %>% 
  #filter(if("season" %in% names(.)) season == seas else TRUE) %>%
  input %>% mutate(an = format(data, "%Y")) %>%
    group_by(name) %>% 
    summarise(
      mean_hist = mean(scen_param_mean[an %in% hist_per[1]:hist_per[2]]) %>% round(1),
      mean_scen =  mean(scen_param_mean[an %in% scen_per[1]:scen_per[2]]) %>% round(1),
      change = case_when(
        substr(param,1,2) == "pr" ~  (((mean_scen*100)/mean_hist) - 100)  %>% round(1),
        substr(param,1,2) != "pr" ~   (mean_scen - mean_hist)  %>% round(1)
      )
    )
}



