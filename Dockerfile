FROM node:20-alpine AS base

WORKDIR /app

RUN apk update && apk upgrade
RUN apk add --no-cache gcompat=1.1.0-r4 && rm -rf /var/cache/apk/*

COPY package*.json ./

RUN npm ci --omit=dev
RUN npm install -g npm@10.9.0 && \
    # Remove old version
    npm uninstall -g cross-spawn && \
    npm cache clean --force && \
    # Find and remove any remaining old versions
    find /usr/local/lib/node_modules -name "cross-spawn" -type d -exec rm -rf {} + && \
    # Install new version
    npm install -g cross-spawn@7.0.5 --force && \
    # Configure npm
    npm config set save-exact=true && \
    npm config set legacy-peer-deps=true

COPY . .

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

CMD ["node", "server.js"]
