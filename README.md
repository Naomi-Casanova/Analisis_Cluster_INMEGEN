Analisis_Cluster_INMEGEN
===  
Análisis de las cargas totales y el uso de RAM semanal en las computadoras en INMEGEN 

Codigo base que reproduce mi analisis de memoria RAM utilizada y carga semanal 
===  
Contenido
- 3 Scripts para realizar cada uno de los siguientes analisis :
  - Cargas Promedio semanales (  weekly_proccess_analize.R  ) 
  - Numero total de procesos semanales ( weekly_proccess_analize.R  ) 
  - Cantidad de memoria RAM utilizada semanalmente ( total_weekly_RAM_analize.R  )
- Este repositorio sirve para reproducir los resultados en: URL y DOI de tu paper  

Este pipeline toma como INPUT una carpeta con los archivos que contienen las mediciones de uso registradas en las computadoras del Instituto.
Cada archivo contiene las mediciones referentes a un dia, las cuales fueron tomadas en ticks de entre 15 y 20 minutos aproximadamente.
Contacte a Israel Aguilar (iaguilaror@gmail.com) para saber el origen de los datos en detalles.  

Cada pipeline entrega como OUTPUT una tabla CSV que contiene los resultados obtenidos , asi como una grafica en PNG para su visualizacion.

OUTPUTS:

1) Script : " total_weekly_RAM_analize.R "
   
    - total_weekly_RAM.csv tabla que resume la cantidad de RAM utilizada, asi como la cantidad de RAM disponible;  
    - total_weekly_RAM.png  grafica ilustrativa de los datos generados en  weekly_RAM.png;
    
2) Script : " total_weekly_processes_analize.R "
   
    - total_weekly_Process.csv  tabla que resume el numero de procesos usados, asi como la cantidad de procesos disponibles;  
    - total_weekly_Process.png   grafica ilustrativa de los datos generados en total_weekly_Process.png;

3) Script : " weekly_proccess_analize.R "

    - weekly_Process.csv tabla que resume la carga promedio semanal;  
    - weekly_Process.png grafica ilustrativa de los datos generados en weekly_Process.csv;
     
---
### Features
  **-v 0.0.1**

* Recibe una carpeta con los archivos de las mediciones.
* Los resultados incluyen tablas limpias y graficos sencillos
* Corre en R
  
---

## Requisitos
#### OS compatible:
* Windows 11

#### OS incompatible:
* DESCONOCIDO  

\* El codigo puede correr en LINUX y macOS pero se necesitan pruebas.  

#### Requisitos de software:
| Requisito | Version  |
|:---------:|:--------:|
| [R](https://www.r-project.org/) | 4.3.2 |

#### Raquetes R requeridos:

```
pacman: 0.5.1
vroom: 1.6.5
dplyr: 1.1.4
ggplot2: 3.5.0
```

---

### Instalacion
Descarga este pipeline desde el repositorio
```
git clone git@github.com:Naomi-Casanova/Analisis_SNI.git
```

---

## Replica mi analisis!:

* Tiempo de ejecucion estimado por archivo :  **5 minuto(s)**  

1. Abre el script:  
```
 weekly_proccess_analize.R 
```

2. Da click en el boton "source" de RStudio.  

3. Abre el script:  
```
weekly_proccess_analize.R
```

4. Da click en el boton "source" de RStudio.

5. Abre el script:  
```
total_weekly_RAM_analize.R  
```
6. Da click en el boton "source" de RStudio.

7. Revisa los resultados en la carpeta ./Graficas/  

---


### Pipeline Inputs

* Una carpeta /cluster_logs_para_analisis que contiene los archivos con las mediciones

### Pipeline Outputs

Dentro del directorio results/ puedes encontrar lo siguiente:

#### Imagenes 
* weekly_Process: que muestra el grafico con los promedios de carga semanales. 
* total_weekly_Process.png  : que muestra el grafico con el numero total de procesos utilizados semanalmente.
* total_weekly_RAM.png : que muestra el grafico con la cantidad de RAM utilizada semanalmente.
  
#### Tablas
* weekly_Process.csv : que muestra los promedios de carga semanales. 
* total_weekly_Process.csv  : que muestra el numero total de procesos utilizados semanalmente.
* total_weekly_RAM.csv : que muestra la cantidad de RAM utilizada semanalmente.

---

### Module directory structure

````
.
├── cluster_logs_para_analisis/   # directorio con los datos iniciales
├── total_weekly_RAM_analize.R    # script para limpiar la data/
├── total_weekly_processes_analize.R  # script para generar los graficos de results/
├── weekly_processes_analize.R  # script para generar los graficos de results/
├── Graficas/       # directorio con las tablas y figuras resultantes
└── README.md      # Este readme

````

---
### Referencias
Este repositorio usa varias herramientas de codigo, por favor incluye las siguientes citas en tu trabajo:

* Team, R. C. (2017). R: a language and environment for statistical computing. R Foundation for Statistical Computing, Vienna. http s. www. R-proje ct. org.

---

### Contacto
Si tienes preguntas, solicitudes, o bugs para reportar, abre un issue en github, o envia un email a <naomicasanova_nncr@ciencias.unam.mx>  

### Dev Team
Israel Aguilar-Ordonez <iaguilaror@gmail.com>   
Naomi-Casanova <naomicasanova_nncr@ciencias.unam.mx>

### Cita nuestro trabajo
https://link.springer.com/article/10.1007/s11357-023-00977-1

