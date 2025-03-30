# Backend Service
FROM node:18-alpine

WORKDIR /app

# Add hadolint ignore for npm install
# hadolint ignore=DL3016
COPY package*.json ./
RUN npm ci --only=production

COPY . .

# Use non-root user
USER node

EXPOSE 3000
CMD ["npm", "start"]
