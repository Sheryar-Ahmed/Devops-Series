# DevOps Bootcamp - Session 1: AWS EC2 Deployment

## 📌 Session Goals

- **Introduce DevOps** – What it is, why it matters, and how it transforms software development.
- **AWS IAM Basics** – Understanding Identity and Access Management (IAM) in AWS.
- **Live Deployment** – Deploy a React.js or Node.js application on an EC2 instance using Nginx.
- **Engage Students** – Spark curiosity and interest in DevOps by showing real-world applications.

---

## 🚀 Introduction to DevOps

### What is DevOps?

DevOps is a combination of **Development (Dev)** and **Operations (Ops)** that aims to bridge the gap between software development and IT operations. It enhances collaboration, automation, and deployment efficiency.

### Why DevOps Matters?

- Faster software delivery with **Continuous Integration & Deployment (CI/CD)**.
- **Improved collaboration** between developers and operations teams.
- **Scalability and reliability** with cloud services like AWS.

### Key DevOps Concepts

- **Infrastructure as Code (IaC)** – Automating infrastructure setup with tools like Terraform.
- **Continuous Integration & Deployment (CI/CD)** – Automating testing and deployment.
- **Monitoring & Logging** – Ensuring system reliability with monitoring tools.

---

## 🔐 AWS IAM Basics

AWS IAM (Identity and Access Management) is used to manage access to AWS resources securely.

### Key IAM Concepts:

- **Users & Groups**: Individual accounts or teams with assigned permissions.
- **Roles & Policies**: Define what actions an entity can perform on AWS resources.
- **Security Best Practices**: Use IAM roles instead of root accounts, enable MFA.

### IAM Policy Example:

This policy allows full access to an S3 bucket:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "1",
    "Effect": "Allow",
    "Action": "s3:*",
    "Resource": [
      "arn:aws:s3:::mybucket",
      "arn:aws:s3:::mybucket/*"
    ]
  }]
}
```

---

## 🌍 Deploying React.js & Node.js on a Single AWS EC2 Instance

### 1️⃣ Setting Up the EC2 Instance

#### Step 1: Launch an EC2 Instance

1. Go to **AWS Console** → **EC2** → **Launch Instance**.
2. Choose **Ubuntu 22.04 LTS** as the Amazon Machine Image (AMI).
3. Select **t2.micro** (Free Tier) as the instance type.
4. Configure security group:
   - Allow **SSH (22)** from your IP.
   - Allow **HTTP (80)** and **HTTPS (443)** from anywhere.
5. Add an **SSH Key Pair** and launch the instance.

#### Step 2: Connect to Your Instance

```bash
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

#### Step 3: Update & Install Required Packages

```bash
sudo apt update && sudo apt upgrade -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install 18.18.0 --lts
sudo apt install nginx certbot python3-certbot-nginx -y
```

---

### 2️⃣ Deploying the React.js Frontend

#### Step 1: Build React App

Navigate to your React project and build the production files:

```bash
npm run build
```

#### Step 2: Copy Build Files to Nginx Web Directory

```bash
sudo cp -r build/* /var/www/html/
```

---

### 3️⃣ Deploying the Node.js Backend

#### Step 1: Install PM2 & Clone Repo

```bash
sudo npm install -g pm2
cd /home/ubuntu
git clone <your-nodejs-repo>
cd your-nodejs-repo
npm install
npm run build
npm start
pm2 start server.js --name "node-backend"
pm2 startup
pm2 save
```

---

### 4️⃣ Configuring Nginx as a Reverse Proxy

#### Step 1: Edit Nginx Configuration

```bash
sudo nano /etc/nginx/sites-available/default
```

#### Replace with:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        root /var/www/html;
        index index.html;
        try_files $uri /index.html;
    }

    location /api/ {
        proxy_pass http://localhost:5000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Save and exit (CTRL+X, Y, ENTER).

#### Step 2: Restart Nginx

```bash
sudo systemctl restart nginx
```

---

### 5️⃣ Configuring Domain & SSL

#### Step 1: Point Domain to EC2

- Go to your **domain provider** (GoDaddy, Namecheap, etc.).
- Add an **A record** pointing to your EC2 instance IP.

#### Step 2: Enable HTTPS with Let’s Encrypt SSL

```bash
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

Follow the prompts and ensure SSL is successfully installed.

#### Step 3: Auto-Renew SSL

```bash
sudo systemctl enable certbot.timer
```

---

### 6️⃣ Ensuring Node.js Runs After Reboot

```bash
pm2 save
pm2 startup
```

---

## 🎉 Deployment Complete!

Your React frontend is live on **[https://your-domain.com](https://your-domain.com)** and Node.js API at **[https://your-domain.com/api/](https://your-domain.com/api/)**. 🚀

---

## 📚 Additional Learning Resources

- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Nginx Reverse Proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- [PM2 Process Manager](https://pm2.keymetrics.io/)

---

## 🛠 Repository Structure

```
- node_app/
  - README.md
  - scripts/  (all commands and steps)
  - links to relevant learning materials
```

---

🚀 **Don’t miss this chance to level up your DevOps skills!** 🚀

