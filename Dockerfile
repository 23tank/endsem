# --- Stage 1: Build the Vite React App ---
    FROM node:18-alpine AS build

    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install
    
    COPY . .
    RUN npm run build
    
    
    # --- Stage 2: Serve Build via Nginx ---
    FROM nginx:stable-alpine
    
    # Remove default nginx website
    RUN rm -rf /usr/share/nginx/html/*
    
    # Copy build to Nginx public folder
    COPY --from=build /app/dist /usr/share/nginx/html
    
    # Copy custom nginx config (if you add one)
    COPY nginx.conf /etc/nginx/conf.d/default.conf
    
    EXPOSE 80
    
    CMD ["nginx", "-g", "daemon off;"]
    