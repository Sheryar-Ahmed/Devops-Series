# Contributors Guide

## Step 1: Fork the Repository
1. Go to the repository: **Devops-Series**.
2. Click the **Fork** button at the top right.
3. This will create a copy of the repository under your GitHub account.

## Step 2: Create a New Branch
1. Clone the forked repository to your local machine:
   ```bash
   git clone https://github.com/YOUR-USERNAME/Devops-Series.git
   ```
   *(Replace `YOUR-USERNAME` with your GitHub username.)*
2. Navigate into the project directory:
   ```bash
   cd Devops-Series
   ```
3. Create a new branch named **session/fifth**:
   ```bash
   git checkout -b session/fifth
   ```

## Step 3: Create a Folder for Session 5
1. Inside the **devops_session** directory, create a new folder named **session_5**:
   ```bash
   mkdir -p devops_session/session_5
   ```

## Step 4: Add a README and Other Necessary Files
1. Navigate to the new folder:
   ```bash
   cd devops_session/session_5
   ```
2. Create a `README.md` file:
   ```bash
   touch README.md
   ```
3. Open the file and document all the session material, including:
   - Explanation of concepts covered in **Episode 5**.
   - Any **configurations** or **commands** used.
   - If there are any shell scripts, create a `.sh` file:
     ```bash
     touch setup_script.sh
     ```
   - Add execution permissions for the script (if applicable):
     ```bash
     chmod +x setup_script.sh
     ```
4. Edit the files using a text editor (e.g., VS Code, Nano, Vim).

## Step 5: Commit and Push Changes
1. Add all new files:
   ```bash
   git add .
   ```
2. Commit the changes:
   ```bash
   git commit -m "Added session 5 documentation and related files"
   ```
3. Push the branch to the remote repository:
   ```bash
   git push origin session/fifth
   ```

## Step 6: Sync with the Original Repository and Create a Pull Request
1. Add the original repository as an upstream remote:
   ```bash
   git remote add upstream https://github.com/Sheryar-Ahmed/Devops-Series.git
   ```
2. Fetch the latest changes from the original repository:
   ```bash
   git fetch upstream
   ```
3. Merge the latest `main` branch from the original repository into your current branch:
   ```bash
   git checkout session/fifth
   git merge upstream/main
   ```
4. If any conflicts arise, resolve them and commit the changes.
5. Push the updated branch to your forked repository:
   ```bash
   git push origin session/fifth
   ```
6. On GitHub, go to your **forked repo**, open the **Pull Requests** tab, and click **New Pull Request**.
7. Choose **session/fifth** as the source branch and **main** as the target branch.
8. Add a **title and description**, then create the PR.

## Step 7: Assign a Reviewer
1. In the Pull Request, assign a reviewer (e.g., @Sheryar-Ahmed).
2. Wait for the review and approval.
3. Once approved, the PR will be merged into the **main** branch.

