# TerraWeek Capstone: Multi-Environment Infrastructure with Workspaces and Modules

### Task 1: Learn Terraform Workspaces
Before building the project, understand workspaces:

```bash
mkdir terraweek-capstone && cd terraweek-capstone
```
![](./images/task-1/1-1.png)

```bash
terraform init
```
![](./images/task-1/1-2.png)

```bash
# See current workspace
terraform workspace show                    # default

# Create new workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```
![](./images/task-1/1-3.png)

```bash
# List all workspaces
terraform workspace list
```
![](./images/task-1/1-4.png)

```bash
# Switch between them
terraform workspace select dev
terraform workspace select staging
terraform workspace select prod
```
![](./images/task-1/1-5.png)

Answer:
1. What does `terraform.workspace` return inside a config?

👉 The `terraform.workspace` interpolation sequence returns a string representing the name of the current active workspace.

When we use this variable in our configuration, it allows us to dynamically change resource names, tags, or settings based on the environment we are currently targeting.

2. Where does each workspace store its state file?


👉 **Workspace State Storage**

Terraform keeps the **default** workspace at the primary path we define, while **named workspaces** are isolated in a separate subdirectory or prefix to prevent state corruption.

- **Local Storage:**

    - `default`: `./terraform.tfstate`

    - `others`: `./terraform.tfstate.d/<name>/terraform.tfstate`

- **Remote Storage (e.g., S3):**

    - `default`: `path/to/state.tfstate`

    - `others`: `env:/<name>/path/to/state.tfstate`

**Key Takeaway:** The active workspace is always determined by your local environment context. Use `terraform workspace list` to see which state file you are currently pointing to.

3. How is this different from using separate directories per environment?

👉 The fundamental difference lies in how **we** manage **Isolation vs. Convenience**:

- **Workspaces:** We use the **exact same code** for all environments and switch between them via the CLI. This is fast and reduces code duplication, but it increases our risk because we might accidentally run a command on the wrong environment if we lose track of which workspace is active.

- **Separate Directories:** We use **distinct folders** for each environment (e.g., `/dev` and `/prod`). This provides "physical" isolation—we can use different backend buckets, separate access permissions, and even different versions of our modules for each environment.

**Final Thought:** We generally use workspaces for **temporary or feature testing**, while we rely on separate directories for **production-grade** stability and security.

---

### Task 2: Set Up the Project Structure
Create this layout:

```
terraweek-capstone/
  main.tf                   # Root module -- calls child modules
  variables.tf              # Root variables
  outputs.tf                # Root outputs
  providers.tf              # AWS provider and backend
  locals.tf                 # Local values using workspace
  dev.tfvars                # Dev environment values
  staging.tfvars            # Staging environment values
  prod.tfvars               # Prod environment values
  .gitignore                # Ignore state, .terraform, tfvars with secrets
  modules/
    vpc/
      main.tf
      variables.tf
      outputs.tf
    security-group/
      main.tf
      variables.tf
      outputs.tf
    ec2-instance/
      main.tf
      variables.tf
      outputs.tf
```
![](./images/task-2/2-1.png)

![](./images/task-2/2-2.png)

Create the `.gitignore`:
```
.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
.terraform.lock.hcl
```

**Document:** Why is this file structure considered best practice?

👉 We use this structure because it balances **reusability**, **security**, and **scalability**. Here is why it works:

- **Modularity:** By separating logic into the `modules/` directory, we ensure our code is DRY (Don't Repeat Yourself). We can update a single component, like the `security-group`, without risking the entire stack.

- **Environment Isolation:** We use `.tfvars` files to pass unique data (like CIDR blocks or instance types) to the same set of code. This allows us to maintain identical infrastructure patterns across Dev, Staging, and Prod.

- **Clean Orchestration:** * `main.tf` acts as the high-level "manager" calling our modules.

    - `locals.tf` handles workspace-specific logic, ensuring our resource names stay unique.

    - `providers.tf` centralizes our API connections and backend state.

- **Security Hygiene:** Our `.gitignore` is the first line of defense. It prevents us from accidentally committing sensitive state files, local provider binaries, or secret-laden variables to version control.

By organizing our capstone project this way, we create a professional-grade workflow that is easy for a team to audit and scale.

---

### Task 3: Build the Custom Modules
Create three focused modules:

**Module 1: `modules/vpc/`**
- Input: `cidr`, `public_subnet_cidr`, `environment`, `project_name`
- Resources: VPC, public subnet, internet gateway, route table, route table association
- Output: `vpc_id`, `subnet_id`
- All resources tagged with environment and project 

```bash
cd modules/vpc/
vi variables.tf
```
```hcl
variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}
```

```bash
vi main.tf
```
```hcl
# 1. Create the VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# 2. Create a Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-${var.environment}"
    Environment = var.environment
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  # This ensures the IGW won't even try to move until the VPC is solid
  depends_on = [aws_vpc.this]

  tags = {
    Name = "${var.project_name}-igw-${var.environment}"
  }
}

# 4. Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt-${var.environment}"
  }
}

# 5. Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```
```bash
vi output.tf
```
```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

```

**Module 2: `modules/security-group/`**
- Input: `vpc_id`, `ingress_ports`, `environment`, `project_name`
- Resources: Security group with dynamic ingress rules, allow all egress
- Output: `sg_id`

```bash
cd ../security-group/
vi variables.tf
```
```hcl
variable "vpc_id" {
  description = "The ID of the VPC where the SG will be created"
  type        = string
}

variable "ingress_ports" {
  description = "List of ports to open for ingress"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}
```

```bash
vi main.tf
```
```hcl
resource "aws_security_group" "this" {
  name        = "${var.project_name}-sg-${var.environment}"
  description = "Security group for ${var.project_name} in ${var.environment}"
  vpc_id      = var.vpc_id

  # Dynamic Ingress Rules
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Allow all Egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-sg-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}
```
```bash
vi output.tf
```
```hcl
output "sg_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.this.id
}
```

**Module 3: `modules/ec2-instance/`**
- Input: `ami_id`, `instance_type`, `subnet_id`, `security_group_ids`, `environment`, `project_name`
- Resources: EC2 instance with tags
- Output: `instance_id`, `public_ip`

```bash
cd ../ec2-instance/
vi variables.tf
```
```hcl
variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}
```

```bash
vi main.tf
```
```hcl
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  # Ensure the instance is reachable if in a public subnet
  associate_public_ip_address = true

  tags = {
    Name        = "${var.project_name}-ec2-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}
```
```bash
vi output.tf
```
```hcl
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  # Ensure the instance is reachable if in a public subnet
  associate_public_ip_address = true

  tags = {
    Name        = "${var.project_name}-ec2-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}
```
Write and validate each module:
```bash
terraform validate
```
![](./images/task-3/3-1.png)

---

### Task 4: Wire It All Together with Workspace-Aware Config
In the root module, use `terraform.workspace` to drive environment-specific behavior.

**`locals.tf`:**
```hcl
locals {
  environment = terraform.workspace
  name_prefix = "${var.project_name}-${local.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    Workspace   = terraform.workspace
  }
}
```

**`variables.tf`:**
```hcl
variable "project_name" {
  type    = string
  default = "terraweek"
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ingress_ports" {
  type    = list(number)
  default = [22, 80]
}
```

**`main.tf`** -- call all three modules, passing workspace-aware names and variables.

```bash
vi main.tf
```
```hcl
# 1. Fetch the latest Ubuntu 24.04 AMI automatically for our region
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. Network Layer: Create the VPC and Public Subnet
module "vpc" {
  source             = "./modules/vpc"
  cidr               = var.vpc_cidr
  public_subnet_cidr = var.subnet_cidr
  environment        = local.environment
  project_name       = var.project_name
}

# 3. Security Layer: Create Security Group with Dynamic Ingress Rules
module "security_group" {
  source        = "./modules/security-group"
  vpc_id        = module.vpc.vpc_id
  ingress_ports = var.ingress_ports
  environment   = local.environment
  project_name  = var.project_name
}

# 4. Compute Layer: Deploy the EC2 Instance
module "ec2_instance" {
  source             = "./modules/ec2-instance"
  # We use the Data Source ID here to ensure region compatibility
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.security_group.sg_id]
  environment        = local.environment
  project_name       = var.project_name
}
```

```bash
cat outputs.tf
```
```hcl
output "ec2_public_ip" {
  description = "The public IP of the EC2 instance from the module"
  # This syntax 'module.<NAME>.<OUTPUT>' is the bridge
  value       = module.ec2_instance.public_ip
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance from the module"
  value       = module.ec2_instance.instance_id
}
```

**Environment-specific tfvars:**

`dev.tfvars`:
```hcl
vpc_cidr      = "10.0.0.0/16"
subnet_cidr   = "10.0.1.0/24"
instance_type = "t2.micro"
ingress_ports = [22, 80]
```

`staging.tfvars`:
```hcl
vpc_cidr      = "10.1.0.0/16"
subnet_cidr   = "10.1.1.0/24"
instance_type = "t2.small"
ingress_ports = [22, 80, 443]
```

`prod.tfvars`:
```hcl
vpc_cidr      = "10.2.0.0/16"
subnet_cidr   = "10.2.1.0/24"
instance_type = "t3.small"
ingress_ports = [80, 443]
```

Notice: dev allows SSH, prod does not. Different CIDRs prevent overlap. Instance types scale up per environment.

---

### Task 5: Deploy All Three Environments
Deploy each environment using its workspace and tfvars file:

**Dev:**
```bash
terraform workspace select dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```
![](./images/task-5/5-2.png)

![](./images/task-5/5-3.png)

![](./images/task-5/5-4.png)

![](./images/task-5/5-5.png)

**Staging:**
```bash
terraform workspace select staging
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"
```
![](./images/task-5/5-6.png)

![](./images/task-5/5-7.png)

![](./images/task-5/5-8.png)

![](./images/task-5/5-9.png)


**Prod:**
```bash
terraform workspace select prod
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```
![](./images/task-5/5-10.png)

![](./images/task-5/5-11.png)

![](./images/task-5/5-12.png)

![](./images/task-5/5-13.png)

After all three are deployed, verify:

```bash
# Check each workspace's resources
terraform workspace select dev && terraform output
```
![](./images/task-5/5-14.png)

```bash
terraform workspace select staging && terraform output
```
![](./images/task-5/5-15.png)

```bash
terraform workspace select prod && terraform output
```
![](./images/task-5/5-16.png)


Go to the AWS console and verify:
- Three separate VPCs with different CIDR ranges
- Three EC2 instances with different instance types
- Different Name tags per environment: `terraweek-dev-server`, `terraweek-staging-server`, `terraweek-prod-server`

![](./images/task-5/5-17.png)

![](./images/task-5/5-18.png)

![](./images/task-5/5-19.png)

![](./images/task-5/5-20.png)

![](./images/task-5/5-21.png)

**Verify:** Are all three environments completely isolated from each other?

👉 In our current **TerraWeek Capstone** architecture, the answer is a definitive **yes**. Because we are using **Terraform Workspaces** combined with **Modular AWS Resources**, we have achieved "Logical Isolation."

---

### Task 6: Document Best Practices
Write down everything you have learned this week as a Terraform best practices guide:

1. **File structure** -- separate files for providers, variables, outputs, main, locals
2. **State management** -- always use remote backend, enable locking, enable versioning
3. **Variables** -- never hardcode, use tfvars per environment, validate with `validation` blocks
4. **Modules** -- one concern per module, always define inputs/outputs, pin registry module versions
5. **Workspaces** -- use for environment isolation, reference `terraform.workspace` in configs
6. **Security** -- .gitignore for state and tfvars, encrypt state at rest, restrict backend access
7. **Commands** -- always run `plan` before `apply`, use `fmt` and `validate` before committing
8. **Tagging** -- tag every resource with project, environment, and managed-by
9. **Naming** -- consistent prefix pattern: `<project>-<environment>-<resource>`
10. **Cleanup** -- always `terraform destroy` non-production environments when not in use

👉 Here is our comprehensive **Terraform Best Practices Guide** based on everything we implemented:

**1. File Structure**

We maintain a clean, "separation of concerns" layout. Instead of a single monolithic file, we use:

- `providers.tf`: Configures AWS and required versions.

- `variables.tf` & `outputs.tf`: Defines inputs and success metrics.

- `main.tf`: The primary orchestration logic.

- `locals.tf`: For derived data (like common tags) to keep code DRY.

**2. State Management**

The state file is the "source of truth."

- **Remote Backend:** We store state in S3 to allow team collaboration.

- **State Locking:** We use DynamoDB to prevent two people from running `apply` at once.

- **Versioning:** We enable versioning on the S3 bucket to recover from accidental state corruption.

**3. Variables**

Hardcoding is the enemy of automation.

- **No Hardcoding:** Always use variables for regions, instance types, and IDs.

- **Environment-Specific:** Use `.tfvars` files (e.g., `prod.tfvars`, `dev.tfvars`) to inject values.
**
- **Validation:** Use `validation` blocks within variables to ensure inputs (like CIDR blocks) meet security standards.

**4. Modules**

Modules should be "Lego blocks" for infrastructure.

- **Single Concern:** A module should do one thing (e.g., just VPC or just EC2).

- **Inputs/Outputs:** Modules must be black boxes; only interact with them through defined variables and outputs.

- **Version Pinning:** When using registry modules, always pin to a specific version to avoid breaking changes.

**5. Workspaces**

We use workspaces for environment isolation.

- **Logical Separation:** Workspaces (`dev`, `staging`, `prod`) allow us to use the same code to manage different environments.

- **Dynamic Referencing:** Use `terraform.workspace` in your code to automatically name resources based on the active environment.

**6. Security**

Infrastructure code must be as secure as application code.

- **Secrets:** Never commit `.tfstate`or `terraform.tfvars` to Git. Use a robust `.gitignore`.
`
- **Encryption:*** Always encrypt the S3 backend at rest.

- **IAM:** Restrict backend access using the principle of least privilege.

**7. Commands & Workflow**

A disciplined terminal workflow prevents outages.

- **The Golden Rule:** Never `apply` without a `plan` first.

- **Linting:** Run `terraform fmt` to keep code clean and `terraform validate` to catch syntax errors before they hit the cloud.

**8. Tagging**

If you can't label it, you can't bill it or manage it.

- **Standardized Tags:** Every resource must have `Project`, `Environment`, and `ManagedBy: Terraform`. This is vital for cost tracking and resource organization.

**9. Naming Conventions**

Consistency prevents confusion in the AWS Console.

- **Predictable Patterns:** Use a pattern like `<project>-<environment>-<resource>` (e.g., `terra-prod-vpc`). This makes searching and filtering instantaneous.

**10. Cleanup & Lifecycle**

Resource management includes knowing when to say goodbye.

- **Automated Destruction:** Always run `terraform destroy` on non-production environments after testing to avoid unnecessary costs.

- **Verification:** As we did today, always run a final CLI sweep to ensure the account is at a "Zero-Resource State" post-cleanup.

---

### Task 7: Destroy All Environments
Clean up all three environments in reverse order:

```bash
terraform workspace select prod
terraform destroy -var-file="prod.tfvars"
```
![](./images/task-7/7-1.png)

![](./images/task-7/7-2.png)

```bash
terraform workspace select staging
terraform destroy -var-file="staging.tfvars"
```
![](./images/task-7/7-3.png)

![](./images/task-7/7-4.png)

```bash
terraform workspace select dev
terraform destroy -var-file="dev.tfvars"
```
![](./images/task-7/7-5.png)

![](./images/task-7/7-6.png)

Verify in the AWS console -- all VPCs, instances, security groups, and gateways should be gone.

![](./images/task-7/7-7.png)

![](./images/task-7/7-8.png)

![](./images/task-7/7-9.png)

![](./images/task-7/7-10.png)

Delete the workspaces:
```bash
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod
```
![](./images/task-7/7-11.png)

**Verify:** Is your AWS account completely clean?

👉 Successfully achieved a zero-resource state post-project. All custom infrastructure was terminated, ensuring the account is clean and cost-optimized.

---
