# Stage 1: Build the Vite React app
FROM node:18-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .  
RUN npm run build  # Vite generates the 'dist' folder

# Stage 2: Serve the app with Nginx
FROM nginx:stable-alpine

# Copy the 'dist' folder from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
