# Cloud Web Server Deployment & Management

## Commands Used
---
### Part 1: Launch Cloud Instance & SSH Access
**Step 1: Create a Cloud Instance**
- Choose Ubuntu 24.04 as the OS image
- Select instance type (e.g., t3.micro for AWS free tier)
- Configure key pair for SSH access

**Step 2: Connect via SSH**
```bash
ssh -i ~/Downloads/demoKeyPair.pem ubuntu@54.84.28.224
```
---

### Part 2: Install Nginx

**Step 1: Update System**
```bash
sudo apt update && sudo apt upgrade -y
```
**Step 2: Install Nginx**
```bash
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```
**Step 3: Verify Nginx is Running**
```bash
systemctl status nginx
```
### Part 3: Configure Security Group

- Allow inbound traffic on port 80 (HTTP) in your cloud provider’s security group/firewall settings.

**Test Web Access:** Open browser and visit:
```bash
http://54.84.28.224
```
Well will see the Nginx welcome page!

### Part 4: Extract and Save Nginx Logs

**Step 1: View Nginx Logs**
```bash
sudo journalctl -u nginx
```
**Step 2: Save Logs to File**
```bash
sudo journalctl -u nginx > nginx-logs.txt
```
**Step 3: Download Log File to Local Machine**
```bash
scp -i demoKeyPair.pem ubuntu@54.84.28.224:~/nginx-logs.txt .
```
---
## Challenges Faced
- Nothing major

## What I Learned
- How to launch and connect to a cloud instance
- Installing and managing Nginx on Ubuntu
- Configuring security groups for web access
- Using journalctl to extract logs
- Verifying a live webpage from the internet
---