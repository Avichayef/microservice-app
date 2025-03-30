# Initial Project Setup Guide

## 1. Create GitHub Repository
1. Go to GitHub.com and log in
2. Click "New repository"
3. Fill in:
   - Repository name: microservice-app
   - Description: Microservice infrastructure with CI/CD pipeline
   - Make it Private
   - Don't initialize with README (we'll push our existing one)

## 2. Initialize Local Git Repository
```bash
# Navigate to your project directory
cd your-project-directory

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Microservice infrastructure setup"
```

## 3. Connect and Push to GitHub
```bash
# Add the remote repository (replace with your GitHub repo URL)
git remote add origin https://github.com/Avichayef/microservice-app.git

# Push to main branch
git branch -M main
git push -u origin main
```

## 4. Configure GitHub Repository Settings
1. Go to repository Settings > Secrets and Variables > Actions
2. Add required secret:
   - Name: `AWS_ACCOUNT_ID`
   - Value: Your 12-digit AWS account ID

## 5. Enable GitHub Actions
1. Go to repository Actions tab
2. Click "I understand my workflows, go ahead and enable them"

## 6. Verify Setup
1. Check GitHub repository to ensure all files are pushed
2. Verify GitHub Actions is enabled
3. Confirm the secret is set

## Next Steps
Once the repository is set up, proceed with the deployment steps in DEPLOYMENT.md:
1. Clone the repository (fresh clone from GitHub)
2. Configure AWS credentials
3. Run local tests
4. Deploy infrastructure

## Important Notes
- Make sure no sensitive information (AWS credentials, etc.) was committed
- Review all files before pushing to ensure no personal/sensitive data is included
- The CI/CD pipeline will start automatically on the first push to main