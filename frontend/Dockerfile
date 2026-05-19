FROM node:20-alpine

# Dossier de travail
WORKDIR /app

# Copie du package.json
COPY app/package*.json ./

# Installation des dépendances (sans npm ci)
RUN npm install --force

# Installer Angular CLI globalement
RUN npm install -g @angular/cli

# Copie du reste du code source
COPY app/ .

# Expose le port Angular
EXPOSE 4200

# Démarrer avec ng serve directement
CMD ["ng", "serve", "--host", "0.0.0.0"]