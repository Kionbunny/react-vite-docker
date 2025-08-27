
#Stage 1 builds your app into static files 
# Stage 2 uses Nginx to server those static files on PORT 80


# Stage 1 : Build the app
FROM node:20-alpine AS build 

# Set working directory 
WORKDIR /app

COPY package*.json ./
# install dependencies inside the container 
RUN npm install

#Copy the rest of the project code into container 
COPY . . 
# Build the app 
RUN npm run build 

#Stage 2 : Serve the app using nginx 
FROM nginx:alpine 

# Copy built files from previous stage
 COPY --from=build /app/dist /usr/share/nginx/html
# --from = build copy from the container of the build stage 
# /app/dist is where out built files are in Stage - 1 
# /usr/share/nginx/html is where Nginx expects files to serve by default.
 #Expose port 80 
 EXPOSE 80 
 # Start nginx 
 CMD ["nginx", "-g", "daemon off;"]
#  tells Nginx not to run in the background, but instead keep running in the foreground.
# Why? Because in Docker, if the main process exits, the container stops. So we keep Nginx attached to the container’s main process.
