# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache dumb-init

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

RUN npm install --legacy-peer-deps --omit=dev && \
    npm cache clean --force

ENV NODE_ENV=production
EXPOSE 3001

RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/main.js"]
