# Step 1: Set up the base image with Node.js (used for building the React app)
FROM node:16 AS build

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy package.json and package-lock.json to the container
COPY package*.json ./

# Step 4: Install the dependencies
RUN npm install

# Step 5: Copy the rest of the app's source code
COPY . .

# Step 6: Build the React app for production
RUN npm run build

# Step 7: Set up the server to serve the built app using Nginx
FROM nginx:alpine

# Step 8: Copy the build folder from the previous stage to the Nginx server
COPY --from=build /app/build /usr/share/nginx/html

# Step 9: Copy a custom Nginx configuration file (optional)
# Uncomment the following line if you have a custom nginx.conf file
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Step 10: Expose port 80 to be able to access the app
EXPOSE 80

# Step 11: Start Nginx to serve the React app
CMD ["nginx", "-g", "daemon off;"]
