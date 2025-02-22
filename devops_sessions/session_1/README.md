# 🚀 Node.js Application

This directory contains a simple **Node.js application** that will be deployed on an **AWS EC2 instance** using **PM2** and **Nginx** as a reverse proxy.

---

## 📦 Project Structure

```
node_app/
│── server.js         # Main entry point
│── package.json      # Dependencies
│── package-lock.json # Locked dependencies
│── scripts/          # Deployment & automation scripts
│── logs/             # Logs for debugging
│── .env.example      # Example environment variables
```

---

## 🛠️ Prerequisites

- **Node.js v18+**
- **PM2 (Process Manager)**
- **Nginx (Reverse Proxy)**
- **AWS EC2 Instance (Ubuntu 22.04 recommended)**

---

## 🚀 Setup & Deployment

### 1️⃣ Install Dependencies  
Run the following command to install project dependencies:

```bash
npm install
```

---

### 2️⃣ Start the Server (Local Development)
To run the server locally, use:

```bash
node server.js
```

By default, the app runs on **port 3000**.

---

### 3️⃣ Deploy on EC2 with PM2  
Once inside the `node_app` directory, run:

```bash
pm2 start server.js --name node_app
pm2 save
pm2 restart all
```

To monitor the application:

```bash
pm2 logs
```

---

### 4️⃣ Configure Nginx as a Reverse Proxy  
Ensure Nginx is installed, then configure it to forward traffic:

```bash
sudo nano /etc/nginx/sites-available/default
```

Add the following configuration:

```
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Save and restart Nginx:

```bash
sudo systemctl restart nginx
```

---

## 📌 Environment Variables  

Copy `.env.example` to `.env` and set your variables.

Example:
```
PORT=3000
MONGO_URI=mongodb://your-db-url
JWT_SECRET=your-secret-key
```

---

## 🔥 Logs & Debugging  

To check logs:
```bash
pm2 logs node_app
```

To restart the app:
```bash
pm2 restart node_app
```

---

## 🎉 Success!  
Your **Node.js app is now live** on your EC2 instance! 🚀
```

---

This **README.md** explains everything clearly for setting up and deploying your Node.js app. 🚀 Let me know if you need modifications!