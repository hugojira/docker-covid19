# Se crea la imagen a partir de ubuntu 20.04 LTS
FROM ubuntu:20.04

LABEL autor = "github.com/hugojira"
LABEL version = "1.0"

WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive 
# se instalan los paquetes necesarios, con la version mas reciente a 2021-04-23
RUN  apt-get -y update && \
     apt-get install -yq curl=7.68.0-1ubuntu2.5 nano=4.8-1ubuntu1 \
     unzip=6.0-25ubuntu1 git=1:2.25.1-1ubuntu3.1 csvkit=1.0.2-2

# se crea la carpeta en donde se montara el volumen para extraer los datos del contenedor
RUN mkdir /root/data

# se copia hacia el contenedor el script que servira para descargar y filtrar los datos
COPY descargar-datos.sh descargar-datos.sh 
# hacer el script ejecutable
RUN chmod +x descargar-datos.sh

CMD ["bash"]
