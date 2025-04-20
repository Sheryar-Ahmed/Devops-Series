
---

```md
# 🚀 DevOps Series - Session 6: CI/CD for MERN Stack App using GitHub Actions & EC2 Deployment

In this session, we’ll learn how to **automate the deployment** of a MERN stack (MongoDB, Express, React, Node.js) app using **GitHub Actions** and **Docker**, and deploy it to an AWS EC2 server via SSH.

---

## 📚 What You Will Learn

### 🧠 Core Concepts (Theory)

- 🔧 **CI/CD (Continuous Integration/Continuous Deployment)**  
  A modern DevOps practice where every code push is tested and deployed *automatically*. It reduces manual errors and speeds up development.

- 🧩 **GitHub Actions**  
  A tool inside GitHub that allows you to run **workflows** whenever something happens in your repo (like a push). These workflows define **jobs** made up of **steps**.

- 📦 **Docker**  
  A platform that packages your app and all its dependencies into **containers**, so it runs the same everywhere – your laptop, staging, or production.

- 📤 **DockerHub**  
  Like GitHub for Docker images. We build our app into Docker images and push them here.

- 💻 **AWS EC2 (Elastic Compute Cloud)**  
  A virtual server (VM) in the cloud where we deploy our app.

- 🔒 **GitHub Secrets**  
  Encrypted environment variables stored in GitHub to securely store credentials (e.g., DockerHub login, EC2 key).

---

## 📲 Group & Collaboration Resources

- **Figma Jamboard:** [Open Jamboard](https://www.figma.com/board/RWz9UkoJZxZGwnJlx2m5W6/Devops_session?node-id=0-1&t=b5KvBpDJNEinEYpn-1)

---

## 🛠 Prerequisites

Before starting, make sure you have:

- ✅ A **GitHub** account (to host code & workflows)
- ✅ A **DockerHub** account (to push Docker images)
- ✅ An **AWS EC2 Ubuntu instance** (for deployment)
- ✅ Basic understanding of:
  - Git & GitHub
  - Docker commands
  - How MERN stack works

---

## ✅ Step 1: Project Structure

Let’s create a basic folder structure for our MERN app:

```
/mern-ci-cd
├── client     # React frontend
├── server     # Express backend
├── .github
│   └── workflows
│       └── deploy.yml  # GitHub Actions workflow
```

Each of `client` and `server` folders must contain a `Dockerfile`.

---

## 🧪 Step 2: CI/CD Pipeline Flow

Every time code is **pushed to the `main` branch**, GitHub will:

1. Checkout the repo code
2. Build Docker images (client & server)
3. Push them to DockerHub
4. SSH into EC2
5. Pull latest images
6. Run the containers 🚀

---

### 🧾 Example Workflow: `deploy.yml`

```yaml
name: Deploy MERN App

on:
  push:
    branches: [ main ]  # Trigger only on main branch push

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Login to DockerHub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Build and push Docker images
      run: |
        docker build -t ${{ secrets.DOCKER_USERNAME }}/mern-client ./client
        docker build -t ${{ secrets.DOCKER_USERNAME }}/mern-server ./server
        docker push ${{ secrets.DOCKER_USERNAME }}/mern-client
        docker push ${{ secrets.DOCKER_USERNAME }}/mern-server

    - name: Deploy to EC2 via SSH
      uses: appleboy/ssh-action@v1.0.0
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ubuntu
        key: ${{ secrets.SSH_PRIVATE_KEY }}
        script: |
          docker pull ${{ secrets.DOCKER_USERNAME }}/mern-client
          docker pull ${{ secrets.DOCKER_USERNAME }}/mern-server
          docker stop client || true && docker rm client || true
          docker stop server || true && docker rm server || true
          docker run -d -p 80:80 --name client ${{ secrets.DOCKER_USERNAME }}/mern-client
          docker run -d -p 5000:5000 --name server ${{ secrets.DOCKER_USERNAME }}/mern-server
```

---

## 🔐 Step 3: Configuring GitHub Secrets

Go to your GitHub repo:

`Settings → Secrets → Actions → New repository secret`

Add these:

| Secret Name         | What It Is                                  |
|---------------------|----------------------------------------------|
| `DOCKER_USERNAME`   | Your DockerHub username                      |
| `DOCKER_PASSWORD`   | Your DockerHub password or token             |
| `EC2_HOST`          | Public IP address of your EC2 instance       |
| `SSH_PRIVATE_KEY`   | Private key for SSH (matches EC2 public key) |

---

## 🖥 Step 4: Setup EC2 & Docker

SSH into your EC2 instance:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
newgrp docker
```

✅ Verify:

```bash
docker --version
```

---

## 🧪 Step 5: Linting or Testing (Optional)

You can run tests or lint your code before deployment. Example:

```yaml
- name: Run ESLint
  run: |
    cd client
    npm install
    npm run lint
```

You can also add unit tests for backend or frontend here.

---

## 🚀 Step 6: Deploy via Push

Whenever you push to `main`, it will trigger the deployment:

```bash
git add .
git commit -m "ci/cd: setup pipeline"
git push origin main
```

---

## 🎉 Final Result

- React frontend will be available at:  
  `http://<your-ec2-ip>` (port 80)

- Express backend will be available at:  
  `http://<your-ec2-ip>:5000`

---

## 🧰 Troubleshooting

| Problem                         | Possible Fix                                               |
|---------------------------------|------------------------------------------------------------|
| ❌ Docker push fails (403)      | Check DockerHub credentials in secrets                     |
| ❌ SSH permission denied        | Ensure private key in GitHub matches public key on EC2     |
| ❌ Can't access app on browser  | Check EC2 security group – open ports 80 and 5000          |

---

## ✅ Best Practices

- Use **Docker Compose** for better orchestration
- Add **Nginx** as reverse proxy
- Enable **SSL (HTTPS)** using Let's Encrypt
- Add **Monitoring & Logging** tools like Prometheus, Grafana, or CloudWatch

---

## 📽 Watch the Full Session

🔗 [CI/CD Deploy MERN App with GitHub Actions + Docker + EC2](https://youtu.be/xgj6vzs2HNs?feature=shared)

---

## 🧠 Recap: What You Learned

- What CI/CD is and why it's important
- How GitHub Actions automate deployment
- How Docker helps with consistent builds
- How to push Docker images to DockerHub
- How to SSH into EC2 and deploy live

---

> 💬 Have questions? Drop them in the WhatsApp group or raise a GitHub issue.
```

---