El script de bash de este proyecto se encarga de descargar los datos de COVID-19 de la Secretaria de Salud Federal mediante el comando ```curl``` y los descomprime con ```unzip```

```bash
curl -O http://datosabiertos.salud.gob.mx/gobmx/salud/datos_abiertos/datos_abiertos_covid19.zip
unzip *.zip
```

Para lo siguiente hace uso de la paquetería ```csvkit``` que sirve para manipular archivos ```.csv``` desde la terminal. Entonces filtra el conjunto de datos para dejar los casos sin comorbilidades excepto obesidad y tabaquismo, donde el número "2" indica negativo 

```bash
csvgrep -c DIABETES,EPOC,ASMA,INMUSUPR,HIPERTENSION,OTRA_COM,CARDIOVASCULAR,RENAL_CRONICA -m "2" *.csv > tabaq_obesidad.csv
```

Ahora, deja los datos solamente con las columnas de las variables que se dejaran para el análisis, las cuales son el sexo, entidad de residencia, fecha de defunción, edad, obesidad, tabaquismo y clasificación final

```bash
csvcut -c SEXO,ENTIDAD_RES,FECHA_DEF,EDAD,OBESIDAD,TABAQUISMO,CLASIFICACION_FINAL tabaq_obesidad.csv > tabaq_obesidad_filtrado.csv
```

Para terminar el procesamiento, remueve los casos no específicados de obesidad y tabaquismo, y deja solamente los positivos (1) y negativos (2), esto para poder hacer comparaciones entre personas con y sin dichas comorbilidades; además de que deja solamente los casos confirmados de COVID-19 que son los valores 1, 2 y 3 en la variable ```CLASIFICACION_FINAL```

```bash
csvgrep -c OBESIDAD,TABAQUISMO -r "[12]" tabaq_obesidad_filtrado.csv | csvgrep -c CLASIFICACION_FINAL -r "[123]" > tabaq-obesidad-covid19.csv
```
Lo que resta es mover el conjunto de datos resultante ```tabaq-obesidad-covid19.csv``` a la carpeta ```/root/data``` y remover los otros archivos que ya no se utilizarán

```bash
mv tabaq-obesidad-covid19.csv data
rm *.csv
rm *.zip
```

