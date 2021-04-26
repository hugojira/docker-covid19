# Contenido
Este repositorio contiene un Dockerfile que crea una imagen de docker basada en Ubuntu 20.04 LTS que a su vez contiene un script bash para descargar y limpiar datos de covid-19 de la Secretaría de Salud Federal de México, el cual estará al crear un contenedor de dicha imagen. Los archivos necesarios para crear la imagen se encuentran en la carpeta [docker-csvkit](/docker-csvkit).

Los datos que se filtraran se pueden encontrar en la [base de datos abierta de la Dirección General de Epidemiología](https://www.gob.mx/salud/documentos/datos-abiertos-152127).

## Propósito de la limpieza de los datos
El propósito es filrar los datos para tener las características que describan si el paciente tiene las comorbilidades obesidad y tabaquismo solamente, esto es, que no tengan otras comorbilidades como diabetes, hipertensión, asma, etc. Además de lo anterior se seleccionan solamente los casos confirmados de COVID-19.

Esto con el propósito de tener un registro de la presencia de dichas comorbilidades en México y el riesgo que conlleva a complicar la enfermedad por COVID-19 y lamentablemente fallecer, de manera que se pueda cuantificar el riesgo y crear más conciencia para que las personas que las padezcan tengan mucha precaución y que además se siga haciendo enfásis en la ayuda de salud pública con asesoría nutricional y tratamientos para dejar de fumar. 

El objetivo es que una vez filtrados los datos con el script dentro del contenedor de docker, ya estén listos para usarse en una herramienta más especializada como Python o R y hacer el respectivo análisis.

## Variables consideradas
Las variables que deja el script después de filtrar los datos son (en mayúsculas el nombre de las columnas en el archivo csv):
* Sexo: SEXO
* Entidad de residencia: ENTIDAD_RES
* Fecha de defunción: FECHA_DEF
* Edad: EDAD
* Obesidad: OBESIDAD
* Tabaquismo: TABAQUISMO
* Clasificación final: CLASIFICACION_FINAL

# Dockerfile y script bash
## Crear imagen con el Dockerfile
Para crear la imagen necesaria se deberá estar en la carpeta [docker-csvkit](/docker-csvkit) como directorio de trabajo y ejecutar en la terminal

```bash
docker build -t <nombre-imagen>:<tag> .
```
donde ```<nombre-imagen>``` y ```<tag>``` son el nombre y etiqueta que le quiera dar a la imagen, respectivamente.

En este caso, nuestro Dockerile creará la imagen de Ubuntu 20.04 con los siguientes **paquetes** y sus respectivas *versiones*:

* **nano** *4.8-1ubuntu1*
* **cvskit** *1.0.2-2*
* **unzip** *6.0-25ubuntu1*
* **git** *1:2.25.1-1ubuntu3.1*
* **curl** *7.68.0-1ubuntu2.5*

**NOTA:** Debe procurarse mantener el directorio [docker-csvkit](/docker-csvkit) solamente con los dos archivos ```Dockerfile``` y ```descargar-datos.sh``` necesarios para crear la imagen al momento de hacer el comando ```biuld```, esto para evitar posibles errores o conflictos.

## Crear el contenedor
Para poder extraer los datos que se filtrarán con el contenedor, es necesario montar un volumen del directorio ```/root/data``` del contenedor con un directorio que usted desee en su sistema operativo al crear el contenedor. Esto se hace con

```bash
docker run --rm -it -v <directorio-local>:/root/data --name <nombre-contenedor> <nombre-imagen>
```

Se recomienda ampliamente siempre crear el contenedor con ```--rm``` para que se elmine al terminar y no ir acumulando contenedores cada vez que desee procesar los datos. También se debe correr de manera interactiva con ```-it``` pues se necesitará la terminal para correr el script que manipulará los datos. O bien, puede crearse el contenedor sin ```-rm```, y si quiere acceder de nuevo a el usar

```bash
docker start -ai <nombre-contenedor>
```

## Ejecutar el script de bash

Una vez dentro del contenedor se verá lo siguiente

![image](/docs/Docker-container-files.png)

Para descargar los datos y procesarlos, ejecute el script ```descargar-datos.sh``` con

```bash
bash descargar-datos.sh
```

El script irá informando en la terminal el procesamiento que se vaya haciendo paso por paso, al terminar indicará que los datos resultantes se guardaron en el archivo ```tabaq-obesidad-covid19.csv``` en el directorio ```/root/data```, por lo que ya podrán extraerse del directorio local en donde se montó el volumen. Los datos ya estarán listos para hacer análisis en un lenguaje de programación especializado como R o Python.

## Ejemplo
A continuación, un ejemplo del script corriendo en el contenedor creado con el Dockerfile

![image](/docs/Docker-csvkit-data.png)

En este caso partícular con un nombre de imagen ```docker-covid-prueba``` y nombre del contenedor ```docker-csvkit``` con el volumen montado en el directorio local ```/Users/hugo/Documents```.
