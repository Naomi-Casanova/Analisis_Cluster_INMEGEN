
# Loadding packages
pacman::p_load( "purrr", "vroom", "dplyr", "tidyr",
                "ggplot2", "stringr", "lubridate",
                "scales" )

# Listing of all log files
all_logs <- list.files( path = "cluster_logs_para_analisis/",
                        pattern = ".tsv.gz",
                        full.names = TRUE )

# Organizing log files names by date and time 
all_logs_metadata <- data.frame( full_path = all_logs ) %>% 
                     mutate( basename = basename( full_path ) ) %>% 
                     separate( col = basename,
                               into = c( "date", "time" ) , 
                               sep = "_" ,
                               remove = FALSE, 
                               extra = "drop" ) %>% 
                     separate( col = date,
                               into = c( "year", "month", "day" ) ) %>% 
                     separate( col = time,
                               into = c( "hour", "minute") ) 
# Sampling ---------------------------------------------------------------------
# Getting the number of logs by period 
  all_logs_metadata  %>% 
  group_by( year ) %>% 
  summarise( logs_n = n( ) )

# Selecting conditions for sampling
sampled_logs <- all_logs_metadata %>% 
                filter( minute == "00" ,
                        hour == "10" | hour == "22"  ) %>%
                pull( full_path )

# FOR TESTING ====
# all_logs <- all_logs %>%  sample( ., 750 )

# Creating a function to read a log and tag it with the date--------------------
read_and_tag.f <- function( the_file ){
      
   date_and_time.tmp <- the_file %>% 
                        basename( ) %>% 
                        str_split( pattern = "_" ) %>% 
                        unlist( )
  
   df.tmp <- vroom( file = the_file ) %>% 
             mutate( date = ymd( date_and_time.tmp[1] ),
                     time = hm( date_and_time.tmp[2] ) )
  
 } # end of read_and_tag.f function 

# Reading all logs into a single dataframe--------------------------------------
all_test <- sampled_logs %>%  
            map_df( ~ read_and_tag.f( . ) )

# Data handling ----------------------------------------------------------------
all_test_split <- all_test %>% 
                  separate( col = date,
                            into = c( "year", "month", "day" ),
                            sep = "-", remove = FALSE )

# Working with load average test
load_data <- all_test_split %>% 
             filter( test == "load_avg_1min" ) %>% 
             separate( col = value,
                       into = c( "load", "max_load" ),
                       sep = "/" ) %>% 
             mutate( load = as.numeric( load ) ,
                     max_load = as.numeric( max_load) ,
                     load_usage_fraction = load / max_load) 

# Adding "n_week" and "week" columns 
load_by_week <- load_data %>%
                mutate( n_of_week = if_else( month(date) == 12 & week(date) == 53 , 52 ,  
                               week(date)))  %>%
                group_by(  n_of_week ) %>% 
                mutate(  start_of_week = floor_date( min(date) , "week" ),
                         end_of_week = start_of_week + days(6) ,
                         week = paste(start_of_week,end_of_week, sep = ' / ')) %>%
                select( week,time,load,max_load,registered_name)%>%
                ungroup()

# Computatitng the total of usage and available load ---------------------------
usaged <- load_by_week %>%
          group_by( week ) %>% 
          summarise( carga_tot_usad = sum(load)) %>%
          ungroup( )

available <- load_by_week %>%
             filter( time == "22H 0M 0S") %>%
             group_by( week ) %>% 
             summarise( carga_tot_dispo = sum(max_load)) %>%
             ungroup( )

# Merge de data with the totals 
 weekly_total <- merge( x = usaged , y = available) %>%
                 mutate ( proportion_usage = round((carga_tot_usad/carga_tot_dispo)*100,
                                                    digits = 2))
               

# Plot -------------------------------------------------------------------------
ggplot( data = weekly_total) +
  geom_bar(aes( x = week,
                y = carga_tot_dispo , fill = "Disponibles" ),
           stat = "identity" ,alpha =0.4 )  +
  geom_bar(aes( x = week,
                y = carga_tot_usad, color ="Utilizados"),
           stat = "identity", fill = "mediumpurple") +
  geom_text(aes(x = week, y = carga_tot_usad, 
            label =paste0(proportion_usage , "%")),
            vjust = -1,
            color = "black",
            size = 1.7) +
  labs( title = "Carga total de procesadores",
        subtitle = "load_avg_1min",
        caption = "Calculado a partir de logs a las 10AM y 10PM",
        color = NULL ,
        fill = "Total de Procesos\n") +
  ylab("Numero de procesos") +
  xlab("Semana") +
  theme_classic( ) +
  theme( plot.title=element_text( face='bold', size=16),
         plot.subtitle=element_text(size=12),
         plot.caption = element_text(size=6),
         axis.title.x = element_text(size=10),
         axis.title.y = element_text(size=10),
         legend.title = element_text(size = 10),
         panel.background = element_rect( fill = "white"),
         panel.grid.major.y   = element_line(color = "gray95",
                                             linewidth  = 0.5,
                                             linetype = 1) ,
         panel.grid.major.x  = element_line(  color = "transparent")   ) +
  theme(axis.text.x = element_text(angle = 65, hjust = 1,size = 6.5)) +
  scale_color_manual(values=c("transparent","transparent"))+
  scale_fill_manual(values = c("Disponibles" = alpha("mediumpurple", 0.4), "Utilizados" = "blue")) 


# ====











