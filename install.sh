#!/usr/bin/env bash
if [ $# -eq 0 ]; then
   echo "Usage: $0 project_name [port]"
else
   pip3 install -U pip
   pip3 install -U django
   if [[ -d "$1" && ! -L "$1" ]]; then
      echo ""
      tput bold;
      printf "Warning: "
      tput sgr 0;
      printf "Project '$1' exists. Remove it if you wish to reinstall. Starting..."
      echo ""
      cd "$1/src"
   else
      django-admin.py startproject --template=https://github.com/orbinary/edge/archive/master.zip --extension=py,md,html,env "$1"
      cd "$1"
      pip3 install -r requirements.txt
      cd src
      cp "$1/settings/local.sample.env" "$1/settings/local.env"
      python manage.py migrate
   fi

   # Fire it up on a custom port if needed
   if [ $# -eq 2 ]; then
      python3 manage.py runserver "0.0.0.0:$2"
   else
      python3 manage.py runserver 0.0.0.0:8001
   fi
fi

