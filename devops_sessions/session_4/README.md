---

# Deploying a Dockerized Application on AWS (ECS, ECR, ALB, Security Groups)

This guide explains how to deploy a **Dockerized application** on AWS using:

- **IAM User & AWS CLI Configuration**
- **Amazon Elastic Container Service (ECS)**
- **Amazon Elastic Container Registry (ECR)**
- **Application Load Balancer (ALB)**
- **Security Groups**
- **Image Management**
- **Networking (VPC, Subnets, Target Groups)**

---

## **1. Creating an IAM User for AWS CLI Authentication**
Before doing anything, we need an **IAM User** with the correct permissions.

1. **Go to AWS IAM Console** → **Users** → Click **Create User**.
2. Enter **User Name**: `aws-ecs-user`.
3. **Select "Access Key - Programmatic Access"** (needed for CLI access).
4. Click **Next: Permissions** → Select **Attach Policies Directly**.
5. Search for `AmazonEC2ContainerRegistryFullAccess`, select it, and click **Next**.
6. Click **Create User**.
7. **Download the `.csv` file** containing **Access Key ID & Secret Access Key**.

---

## **2. Configuring AWS CLI**
Once the IAM user is created, configure the AWS CLI:

```sh
aws configure
```
You'll be prompted to enter:
- **AWS Access Key ID:** (from `.csv` file)
- **AWS Secret Access Key:** (from `.csv` file)
- **Default region name:** (e.g., `us-east-1`, `us-west-2`)
- **Default output format:** (leave blank or type `json`)

To verify if AWS CLI is correctly configured:
```sh
aws s3 ls
```
If no errors appear, your AWS CLI is ready.

---

## **3. Creating Security Groups**
Security groups control incoming and outgoing traffic to **ALB** and **ECS Tasks**.

1. **Go to AWS Console** → **EC2 Dashboard** → **Security Groups**.
2. Click **Create Security Group** → Name it **ALB-SG** (for Load Balancer).
3. **Inbound Rules**:
   - **Type:** HTTP
   - **Protocol:** TCP
   - **Port Range:** `80`
   - **Source:** `0.0.0.0/0` (Allow all)
4. Click **Create Security Group**.

5. **Create another Security Group** → Name it **ECS-SG** (for ECS tasks).
6. **Inbound Rules**:
   - **Type:** Custom TCP Rule
   - **Protocol:** TCP
   - **Port Range:** `3000`
   - **Source:** **ALB-SG** (important: only ALB should access ECS tasks)
7. Click **Create Security Group**.

---

## **4. Creating an ECR Repository**
1. **Go to AWS Console** → **ECR** → **Create Repository**.
2. **Name the repository**: `my-app`
3. **Set visibility to Private**.
4. Click **Create**.
5. Copy the **ECR Repository URI**, e.g.:
   ```
   <aws-account-id>.dkr.ecr.<region>.amazonaws.com/my-app
   ```

---

## **5. Building & Pushing Docker Image to ECR**
1. Authenticate Docker with ECR:
   ```sh
   aws ecr get-login-password | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.<region>.amazonaws.com
   ```

2. Build & tag the image:
   ```sh
   docker build -t my-app .
   docker tag my-app:latest <aws-account-id>.dkr.ecr.<region>.amazonaws.com/my-app:latest
   ```

3. Push the image:
   ```sh
   docker push <aws-account-id>.dkr.ecr.<region>.amazonaws.com/my-app:latest
   ```

---

## **6. Setting Up ECS (Using AWS Console)**
### **Step 1: Create an ECS Cluster**
1. **Go to AWS Console** → **ECS** → **Clusters**.
2. Click **Create Cluster**.
3. **Choose "Networking only (Fargate)"** → Click **Next**.
4. **Cluster Name:** `my-cluster`.
5. Click **Create**.

---

### **Step 2: Create a Task Definition**
1. **Go to AWS Console** → **ECS** → **Task Definitions**.
2. Click **Create new Task Definition**.
3. **Launch Type:** **Fargate**.
4. **Task Definition Name:** `my-task`.
5. **Task Role:** None (default).
6. **Container Name:** `my-app`.
7. **Image:** `<aws-account-id>.dkr.ecr.<region>.amazonaws.com/my-app:latest`.
8. **Port Mapping:** `3000`.
9. **Memory & CPU:** `512 MB, 256 CPU`.
10. Click **Create Task Definition**.

---

### **Step 3: Create ECS Service with ALB**
1. **Go to AWS Console** → **ECS** → **Clusters** → Select `my-cluster`.
2. Click **Create Service**.
3. **Launch Type:** **Fargate**.
4. **Task Definition:** Select `my-task`.
5. **Number of Tasks:** `1` (increase later if needed).
6. **Load Balancer:** **Application Load Balancer**.
7. **Name the ALB**: `my-alb`.
8. **Port:** `80` HTTP.
9. **Target Group:** Keep default.
10. **Under "Networking", select ECS-SG (ECS Security Group)**.

11. Click **Create Service**.

---

## **7. Fixing AWS Glitch with ALB Security Group**
**AWS Glitch:**  
By default, the ALB gets assigned the **ECS Security Group** instead of its own.

1. **Go to AWS Console** → **EC2 Dashboard** → **Load Balancers**.
2. Click **my-alb** → Go to **Security Groups** → **Edit**.
3. **Change it to ALB-SG**.
4. Click **Save**.

---

## **8. Finalizing Security Groups**
| Security Group | Inbound Rules | Outbound Rules |
|---------------|--------------|---------------|
| **ALB-SG** | HTTP, Port `80`, Source: `0.0.0.0/0` | All Traffic `0.0.0.0/0` |
| **ECS-SG** | TCP, Port `3000`, Source: `ALB-SG` | All Traffic `0.0.0.0/0` |

---

## **9. Testing the Deployment**
1. **Find the ALB DNS Name**:
   ```sh
   aws elbv2 describe-load-balancers --query "LoadBalancers[*].DNSName"
   ```
2. Copy the **DNS Name** and open in a browser:
   ```
   http://your-alb-dns-name
   ```
   🎉 Your app is now live!

---

## **10. Cleanup (Optional)**
To delete resources:
```sh
aws ecs delete-service --cluster my-cluster --service my-service --force
aws ecs delete-cluster --cluster my-cluster
aws ecr delete-repository --repository-name my-app --force
aws elbv2 delete-load-balancer --load-balancer-arn <alb-arn>
aws ec2 delete-security-group --group-id <sg-id>
```

---

## **Conclusion**
You have successfully deployed a **Dockerized application** on AWS using **ECS, ECR, ALB, and Security Groups**. This setup ensures **scalability, security, and high availability**. 🚀

For improvements:
- **Enable HTTPS** using ACM SSL
- **Auto Scale ECS Tasks**
- **Set Up CI/CD with GitHub Actions**

```

---