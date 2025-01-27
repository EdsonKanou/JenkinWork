# Utiliser l'image officielle Python
FROM python:3.13.0-alpine3.20

# Définir le répertoire de travail à l'intérieur du conteneur
WORKDIR /app

# Copier le script sum.py dans le répertoire de travail
COPY sum.py .

# Assurez-vous que le conteneur reste actif après son démarrage
CMD ["sh", "-c", "while :; do sleep 2073600; done"]
