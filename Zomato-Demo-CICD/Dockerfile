# Node.js 16 slim as the base image
FROM node:16-slim

# To Set the working directory
WORKDIR /app

# For Copying package .json and package-lock.json to working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copying the rest of the code
COPY . .

# Build the React app
RUN npm run build

# Expose port 3000 (nodejs port)
EXPOSE 3000

# Start Node.js server
CMD ["npm", "start"]
