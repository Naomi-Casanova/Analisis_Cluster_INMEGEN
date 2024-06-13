
########################### TOTAL WEEKLY RAM ANALYSIS ########################## 

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

# Reading all logs into a single dataframe -------------------------------------
all_test <- sampled_logs %>%  
  map_df( ~ read_and_tag.f( . ) )

# Data handling ----------------------------------------------------------------
all_test_split <- all_test %>% 
  separate( col = date,
            into = c( "year", "month", "day" ),
            sep = "-", remove = FALSE )


# Getting the number of logs by period 
all_te
st_split%>% 
  summarize(unique(test))

# Working with load average test
load_data <- all_test_split %>% 
  filter( test == "load_mem" )%>% 
  separate( col = value,
            into = c( "load", "total_mem" ),
            sep = "/" )%>% 
  mutate( mem_uso = substring(load, 1, nchar(load) - 1) ,
          unidades_uso = substring(load, nchar(load), nchar(load)),
          mem_disp= substring(total_mem, 1, nchar(total_mem) - 1) ,
          unidades_disp =  substring(total_mem, nchar(total_mem), nchar(total_mem))
          )%>%
  select(c(5:16) ,-load , -total_mem , -hostname)
# mem_usage_fracton = load / total_mem 

# Cambiando a tipo numerico 
load_data <- load_data%>%
  mutate(mem_uso = as.numeric(mem_uso),
         mem_disp = as.numeric(mem_disp),
         mem_uso_gigas = ifelse( unidades_uso == "T", mem_uso * 1024,
                                 ifelse( unidades_uso == "M", mem_uso/1024, mem_uso)),
         mem_disp_gigas = ifelse( unidades_disp == "T", mem_disp * 1024,
                                 ifelse( unidades_disp == "M", mem_disp/1024, mem_disp)))
# seleccionando solo las columas importantes 
load_data <- load_data %>%
  select (date , time , mem_uso_gigas , mem_disp_gigas)

View(load_data)


# Adding "n_week" and "week" columns 
load_by_week <- load_data %>%
  mutate( n_of_week = if_else( month(date) == 12 & week(date) == 53 , 52 ,  
                               week(date)))  %>%
  group_by(  n_of_week ) %>% 
  mutate(  start_of_week = floor_date( min(date) , "week" ),
           end_of_week = start_of_week + days(6) ,
           week = paste(start_of_week,end_of_week, sep = ' / ')) %>%
  select( week,time,mem_uso_gigas,mem_disp_gigas)%>%
  ungroup()

View(load_by_week)
# Computatitng the total of usage and available load ---------------------------
usaged <- load_by_week %>%
  group_by( week ) %>% 
  summarise( mem_uso_tot_GB = sum(mem_uso_gigas)) %>%
  ungroup( )

available <- load_by_week %>%
  filter( time == "22H 0M 0S") %>%
  group_by( week ) %>% 
  summarise( mem_tot_disp_GB = sum(mem_disp_gigas)) %>%
  ungroup( )

# Merge de data with the totals 
weekly_total_RAM_GB <- merge( x = usaged , y = available) %>%
  mutate ( proportion_usage = round((mem_uso_tot_GB/mem_tot_disp_GB)*100,
                                    digits = 2))

View(weekly_total_RAM_GB)
# Plot -------------------------------------------------------------------------
weekly_total_RAM_GB.G <- ggplot( data = weekly_total_RAM_GB) +
  geom_bar(aes( x = week,
                y = mem_tot_disp_GB , fill = "Disponible" ),
           stat = "identity" ,alpha =0.4 )  +
  geom_bar(aes( x = week,
                y = mem_uso_tot_GB, color ="Utilizada"),
           stat = "identity", fill = "hotpink") +
  geom_text(aes(x = week, y = mem_uso_tot_GB, 
                label =paste0(proportion_usage , "%")),
            vjust = -1,
            color = "black",
            size = 1.7) +
  labs( title = "Total de memoria RAM utilizada ",
        subtitle = "Gigabytes",
        caption = "Calculado a partir de logs a las 10AM y 10PM",
        color = NULL ,
        fill = "Memoria") +
  ylab("Cantidad de memoria\n ") +
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
  scale_fill_manual(name = "Memoria\n",values = c("Disponible" = alpha("hotpink", 0.4))) 

# Saving the plot and the table in a new carpet called "Graficas"
if (!file.exists("Graficas")) {
  dir.create("Graficas")
}

write.csv(weekly_total_RAM_GB, file = "weekly_total_RAM_GB.csv", row.names = FALSE)

ggsave("weekly_total_RAM_GB.png", plot = weekly_total_RAM_GB.G,width = 13.3, height = 7.5)













