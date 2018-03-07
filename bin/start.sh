#!/bin/bash
prueba
NAME="targethome" # Nombre de la aplicación
DJANGODIR=/home/spart4kus/Proyectos/targethome/targethome # Ruta de la carpeta donde esta la aplicación reemplazar <user> con el nombre de usuario
SOCKFILE=/home/spart4kus/Proyectos/targethome/run/gunicorn.sock # Ruta donde se creará el archivo de socket unix para comunicarnos
USER=spart4kus # Usuario con el que vamos a correr la app
GROUP=spart4kus # Grupo con el que se va a correr la app
NUM_WORKERS=3 # Número de workers que se van a utilizar para correr la aplicación
DJANGO_SETTINGS_MODULE=targethome.settings # ruta de los settings
DJANGO_WSGI_MODULE=targethome.wsgi # Nombre del módulo wsgi

echo "Starting $NAME as `whoami`"

# Activar el entorno virtual
cd $DJANGODIR
export WORKON_HOME=~/.virtualenvs
VIRTUALENVWRAPPER_PYTHON='/usr/bin/python3'
source /usr/local/bin/virtualenvwrapper.sh
workon targethome 

export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Crear la carpeta run si no existe para guardar el socket linux
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Iniciar la aplicación django por medio de gunicorn
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=unix:$SOCKFILE \
  --log-level=debug \
  --log-file=-
