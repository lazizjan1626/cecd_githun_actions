# 1. Build stage
FROM node:alpine AS builder
WORKDIR /app

# 2. Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# 3. Install dependencies
RUN npm ci

# 4. Copy the rest of the application code to the working directory
COPY . .

# 5. Build the application
RUN npm run build --prod

# 6. Production stage
FROM node:alpine
WORKDIR /app

# 7. Copy the build output from the builder stage
COPY --from=builder /app/dist ./dist

# 8. Install production dependencies
COPY package*.json ./
RUN npm ci --omit=dev

CMD ["node", "./dist/main.js"]
