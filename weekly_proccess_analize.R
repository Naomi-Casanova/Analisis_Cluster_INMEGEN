
# Load packages
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
                               sep = "_" , remove = FALSE, 
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
                               week(date))) %>%
  group_by(  n_of_week ) %>% 
  summarise( start_of_week = floor_date( min(date) , "week" ),
             end_of_week = start_of_week + days(6),
             weekly_usage_load_mean = mean( load_usage_fraction )) %>% 
  arrange( start_of_week ) %>% 
  mutate ( week = paste(start_of_week,end_of_week, sep = ' / ')) %>%
  ungroup( ) %>% 
  select(week,weekly_usage_load_mean )


#View(weekly_load)

#sorted data from highest to lowest load average 
sorted_weekly_data <- load_by_week %>% 
                      arrange( -weekly_usage_load_mean )

#View(sorted_weekly_data)

# Saving the data 
#write.table(sorted_weekly_data, "sorted_weekly_load_average.tsv", sep="\t", row.names=FALSE)


# Lowest loads in  weekly load average 
n <- length(load_by_week$weekly_usage_load_mean)
lowest_loads <- sorted_weekly_data[ (n-9) :n,]

# Plot
load_plot <- ggplot( data = load_by_week,
        mapping = aes( x = week,
                       y = weekly_usage_load_mean ) ) +
  geom_line( color = "darkturquoise" ,
             linewidth  = 0.75,
             mapping = aes( group = 1 ) )  +
  geom_point( color = "darkturquoise" ,
              size  = 1.5 )  +
  geom_point( data = lowest_loads,
              color = "red",
             size = 2)+
  scale_y_continuous( labels = percent ) +
  labs( title = "Carga de procesadores",
        subtitle = "load_avg_1min",
        caption = "calculado a partir de logs a las 10AM y 10PM" ) +
  ylab("Promedio de carga semanal utilizada") +
  xlab("Semana") +
  theme_classic( ) +
  theme( plot.title=element_text( face='bold', size=16),
         plot.subtitle=element_text(size=12),
         axis.title.x = element_text(size=10),
         axis.title.y = element_text(size=10),
         panel.background = element_rect( fill = "white"),
         panel.grid.major.y   = element_line(color = "gray95",
                                             linewidth  = 0.5,
                                             linetype = 1) ,
         panel.grid.major.x  = element_line(  color = "transparent")   ) +
  theme(axis.text.x = element_text(angle = 65, hjust = 1,size = 6.5)) 






# Plot -------------------------------------------------------------------------

# Saving the plot and the table in a new carpet called "Graficas"
if (!file.exists("Graficas")) {
  dir.create("Graficas")
}

write.csv(load_by_week, file = "weekly_load.csv", row.names = FALSE)

ggsave("weekly_load.png", plot = load_plot ,width = 13.3, height = 7.5)

# Creating tableswith the Top 10 of lowest load average
top5_high_load <-  load_by_week %>%
                  slice_max(order_by = weekly_usage_load_mean, n = 5)
top5_low_load <-  load_by_week %>%
  slice_min(order_by = weekly_usage_load_mean, n = 5)










