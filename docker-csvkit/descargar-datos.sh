# Este script sirve para descargar datos de covid19 de la secretaria de salud
# federal y filtrarlos de acuerdo a un determinado criterio, en este caso
# dejar a los casos confirmados que tienen comorbilidades obesidad y tabaquismo solamente

# Descargar los datos y descomprimirlos
echo "Descargando datos y posteriormente descomprimiendo..."
curl -O http://datosabiertos.salud.gob.mx/gobmx/salud/datos_abiertos/datos_abiertos_covid19.zip
unzip *.zip

# Se quitan las comorbilidades a excepcion de obesidad y tabaquismo
echo "Removiendo casos con comorbilidades, excepto obesidad y tabaquismo..."
csvgrep -c DIABETES,EPOC,ASMA,INMUSUPR,HIPERTENSION,OTRA_COM,CARDIOVASCULAR,RENAL_CRONICA -m "2" *COVID19MEXICO.csv > tabaq_obesidad.csv

# Seleccionamos las variables para el analisis
echo "Extrayendo columnas que se usaran en este analisis..."
csvcut -c SEXO,ENTIDAD_RES,FECHA_DEF,EDAD,OBESIDAD,TABAQUISMO,CLASIFICACION_FINAL tabaq_obesidad.csv > tabaq_obesidad_filtrado.csv

# Se eliminan los casos no especificados de obesidad y tabaquismo, mantenemos solo positivo (1) y negativo (2)
echo "Removiendo casos no especificados de obesidad y tabaquismo, y extrayendo solamente casos positivos de covid19..."
csvgrep -c OBESIDAD,TABAQUISMO -r "[12]" tabaq_obesidad_filtrado.csv | csvgrep -c CLASIFICACION_FINAL -r "[123]" > tabaq-obesidad-covid19.csv

# Se mueve el archivo csv resultante a la carpeta data donde esta montado el volumen de docker
# mkdir data
mv tabaq-obesidad-covid19.csv data
echo "Los datos resultantes han sido movidos a la carpeta data en donde se encuentra montado el volumen de docker."
# Se eliminan los datos de procesamiento y se deja solo el conjunto de datos resultante
rm *.csv
rm *.zip