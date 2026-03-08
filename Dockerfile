FROM node:24-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Corepack para concseguir usar qualquer package manager, no nosso caso, o pnpm
RUN corepack enable && corepack prepare pnpm@10.30.0 --activate

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
COPY prisma ./prisma/

# ------- Dependencies -------
# Instalando dependencias
FROM base AS deps

# Se alguma versão do package.json estiver diferente do lockfile, não vai prosseguir
RUN pnpm install --frozen-lockfile

# ------- Build -------
FROM deps AS build

COPY . .

# Buildando e copiando a pasta com o prisma
RUN pnpm run build && cp -r src/generated dist/generated

# ------- Production -------
FROM base AS production

# Instalando dependencias novamente, mas apenas os de produção
RUN pnpm install --frozen-lockfile --prod --ignore-scripts

# Copiando do build apenas o dist
COPY --from=build /app/dist ./dist

# Rodando aplicação
CMD ["node", "dist/index.js"]


## Multi-Stage Build
# Cada "FROM" é um estagio do Build

# Comando para iniciar o container
# docker build . -t bootcamp-treinos-api