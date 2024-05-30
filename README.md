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

Este pipeline toma como INPUT una carpeta con los archivos que contienen las mediciones de uso tomadas de las computadoras del Instituto.
Cada archivo contiene las mediciones referentes a un dia, las cuales fueron tomadas en ticks de entre 15 y 20 minutos aproximadamente.
Contacte a Israel Aguilar (iaguilaror@gmail.com) para saber el origen de los datos en detalles.  

Cada pipeline entrega como OUTPUT una tabla CSV que contiene los resultados obtenidos , asi como una grafica en PNG para su visualizacion.

OUTPUTS:

1) Script : " total_weekly_RAM_analize.R "
   
    - weekly_RAM.csv tabla que resume la cantidad de RAM utilizada, asi como la cantidad de RAM disponible;  
    - weekly_RAM.png  grafica ilustrativa de los datos generados en  weekly_RAM.png;
    
2) Script : " total_weekly_processes_analize.R "
   
    - total_weekly_Process.csv  tabla que resume el numero de procesos usados, asi como la cantidad de procesos disponibles;  
    - total_weekly_Process.png   grafica ilustrativa de los datos generados en total_weekly_Process.png;

3) Script : " weekly_proccess_analize.R "

    - weekly_Process.csv tabla que resume la carga promedio semanal;  
    - weekly_Process.png grafica ilustrativa de los datos generados en weekly_Process.csv;
     
---
### Features
  **-v 0.0.1**

* Recibe un archivo CSV con el padron resumido
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

#### paquetes R requeridos:

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

* Tiempo estimado:  **5 minuto(s)**  

1. Abre el script:  
```
01-clean.R
```

2. Da click en el boton "source" de RStudio.  

3. Abre el script:  
```
02-grafica.R
```

4. Da click en el boton "source" de RStudio. 

5. Revisa los resultados en la carpeta ./results/  

---


### Pipeline Inputs

* Un archivo data_original.csv que contiene los cambios anuales del SNI 

Ejemplo del archivo  
```
year,nobilis,cambio,miembros
2000,ARQ.,primer ingreso,4
2000,BIOL.,primer ingreso,41
2000,DR.,primer ingreso,4856
2000,DRA.,primer ingreso,1813
2000,FIS.,primer ingreso,3
...
```

---

### Pipeline Outputs

Dentro del directorio results/ puedes encontrar lo siguiente:

* imagen barras.png: que muestra el grafico de cambio del SNI a lo largo del tiempo.  

* imagen pay.png: que muestra el grafico con el total de miembros SNI que ha perdido su distincion, dividido en DRs y DRAs.  

* tabla limpia.csv: que contiene todos los cambios de distincion del SNI desde 2000 a 2020.  

* tabla resumen.csv: que muestra el total de DRs y DRAs que han perdido el SNI.  


---

### module directory structure

````
.
├── data/       	# directorio con los datos iniciales
├── results/       # directorio con las tablas y figuras resultantes
├── 01-clean.R     # script para limpiar la data/
├── 02-grafica.R   # script para generar los graficos de results/
└── README.md      # Este readme

````

---
### Referencias
Este repositorio usa varias herramientas de codigo, por favor incluye las siguientes citas en tu trabajo:

* Team, R. C. (2017). R: a language and environment for statistical computing. R Foundation for Statistical Computing, Vienna. http s. www. R-proje ct. org.

---

### Contacto
Si tienes preguntas, solicitudes, o bugs para reportar, abre un issue en github, o envia un email a <iaguilaror@gmail.com>  

### Dev Team
Israel Aguilar-Ordonez <iaguilaror@gmail.com>   
Naomi-Casanova <naomicasanova_nncr@ciencias.unam.mx>

### Cita nuestro trabajo
https://link.springer.com/article/10.1007/s11357-023-00977-1

