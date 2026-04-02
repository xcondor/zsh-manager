#!/bin/bash

# 系统基础环境变量检测脚本
# 用途：检测常用开发工具、环境变量和系统信息

# 颜色定义
if [[ "$*" != *"--no-color"* ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# 打印分隔线
print_separator() {
    echo -e "${BLUE}========================================${NC}"
}

# 打印成功信息
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# 打印失败信息
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# 打印警告信息
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# 打印信息
print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# 检测命令是否存在
check_command() {
    if command -v "$1" &> /dev/null; then
        print_success "$2 已安装: $(command -v $1)"
        return 0
    else
        print_error "$2 未安装"
        return 1
    fi
}

# 检测环境变量
check_env_var() {
    if [ -n "${!1}" ]; then
        print_success "$1 = ${!1}"
        return 0
    else
        print_warning "$1 未设置"
        return 1
    fi
}

# 开始检测
echo -e "${BLUE}"
echo "╔════════════════════════════════════════════╗"
echo "║     系统基础环境变量检测脚本 v1.0         ║"
echo "╚════════════════════════════════════════════╝"
echo -e "${NC}"

# 系统信息
print_separator
echo -e "${YELLOW}【系统信息】${NC}"
print_separator
echo "操作系统: $(uname -s)"
echo "内核版本: $(uname -r)"
echo "主机名: $(hostname)"
echo "当前用户: $(whoami)"
echo "当前路径: $(pwd)"
echo "系统架构: $(uname -m)"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS 版本: $(sw_vers -productVersion)"
fi
echo ""

# 检测常用开发工具
print_separator
echo -e "${YELLOW}【开发工具检测】${NC}"
print_separator
check_command "git" "Git"
check_command "node" "Node.js"
check_command "npm" "NPM"
check_command "yarn" "Yarn"
check_command "pnpm" "PNPM"
check_command "python3" "Python3"
check_command "pip3" "PIP3"
check_command "java" "Java"
check_command "javac" "Java Compiler"
check_command "mvn" "Maven"
check_command "go" "Go"
check_command "rustc" "Rust"
check_command "cargo" "Cargo"
check_command "docker" "Docker"
check_command "docker-compose" "Docker Compose"
check_command "kubectl" "Kubectl"
check_command "terraform" "Terraform"
check_command "ansible" "Ansible"
check_command "gcc" "GCC"
check_command "make" "Make"
check_command "cmake" "CMake"
echo ""

# 检测Shell环境
print_separator
echo -e "${YELLOW}【Shell环境】${NC}"
print_separator
echo "当前Shell: $SHELL"
echo "Shell版本: $($SHELL --version 2>/dev/null | head -n1)"
echo "用户目录: $HOME"
print_info "PATH: ${PATH//:/$'\n'}" | head -10
echo ""

# 检测常见环境变量
print_separator
echo -e "${YELLOW}【环境变量检测】${NC}"
print_separator
check_env_var "JAVA_HOME"
check_env_var "GOPATH"
check_env_var "GOROOT"
check_env_var "PYTHONPATH"
check_env_var "NODE_PATH"
check_env_var "ANDROID_HOME"
check_env_var "ANDROID_SDK_ROOT"
check_env_var "GRADLE_HOME"
check_env_var "MAVEN_HOME"
check_env_var "DOCKER_HOST"
check_env_var "KUBECONFIG"
check_env_var "TERRAFORM_PLUGIN_CACHE_DIR"
echo ""

# 检测Web开发相关
print_separator
echo -e "${YELLOW}【Web开发环境】${NC}"
print_separator
if command -v node &> /dev/null; then
    echo "NPM全局包路径: $(npm config get prefix)"
    echo "NPM镜像源: $(npm config get registry 2>/dev/null || echo '未设置')"
fi
if command -v python3 &> /dev/null; then
    echo "PIP镜像源: $(pip3 config list 2>/dev/null | grep -i index || echo '未设置')"
fi
echo ""

# 检测数据库
print_separator
echo -e "${YELLOW}【数据库检测】${NC}"
print_separator
check_command "mysql" "MySQL"
check_command "psql" "PostgreSQL"
check_command "redis-cli" "Redis"
check_command "mongod" "MongoDB"
check_command "sqlite3" "SQLite3"
echo ""

# 检测容器和编排
print_separator
echo -e "${YELLOW}【容器和编排】${NC}"
print_separator
if command -v docker &> /dev/null; then
    print_success "Docker 运行中: $(docker version --format '{{.Server.Version}}' 2>/dev/null || echo '未运行')"
    if docker ps &> /dev/null; then
        echo "运行中的容器数: $(docker ps -q 2>/dev/null | wc -l)"
    fi
fi
if command -v kubectl &> /dev/null; then
    if kubectl cluster-info &> /dev/null; then
        print_success "Kubernetes 集群: $(kubectl config current-context 2>/dev/null)"
    else
        print_warning "Kubernetes 未连接"
    fi
fi
echo ""

# 检测IDE和编辑器
print_separator
echo -e "${YELLOW}【常见编辑器/IDE】${NC}"
print_separator
check_command "code" "VS Code"
check_command "vim" "Vim"
check_command "nvim" "Neovim"
check_command "emacs" "Emacs"
check_command "subl" "Sublime Text"
check_command "webstorm" "WebStorm"
check_command "pycharm" "PyCharm"
check_command "idea" "IntelliJ IDEA"
echo ""

# 性能检测
print_separator
echo -e "${YELLOW}【系统资源】${NC}"
print_separator
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "CPU核心数: $(sysctl -n hw.ncpu)"
    echo "内存大小: $(sysctl -n hw.memsize | awk '{print $0/1073741824 " GB"}')"
    # 获取磁盘统计信息
    disk_info=$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 " 使用)"}')
    echo "磁盘使用: $disk_info"
else
    echo "CPU核心数: $(nproc)"
    echo "内存大小: $(free -h | awk '/^Mem:/ {print $2}')"
    # Linux 的 df 输出通常第 3 列是 Used，第 2 列是 Total, 第 5 列是 Percentage
    disk_info=$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 " 使用)"}')
    echo "磁盘使用: $disk_info"
fi
echo ""

# 网络相关
print_separator
echo -e "${YELLOW}【网络配置】${NC}"
print_separator
echo "主机名解析: $(hostname -I 2>/dev/null || echo '无法获取')"
if command -v curl &> /dev/null; then
    echo "外网IP: $(curl -s --max-time 3 ifconfig.me 2>/dev/null || echo '无法获取')"
fi
check_command "ssh" "SSH"
check_command "scp" "SCP"
check_command "rsync" "Rsync"
check_command "wget" "Wget"
check_command "curl" "Curl"
echo ""

# 总结
print_separator
echo -e "${YELLOW}【检测完成】${NC}"
print_separator
echo "脚本执行时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 可选：将结果保存到文件
if [[ "$1" == "--non-interactive" ]]; then
    exit 0
fi

read -p "是否将检测结果保存到文件? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    output_file="env_check_$(date '+%Y%m%d_%H%M%S').log"
    {
        echo "系统环境检测报告 - $(date)"
        echo "========================================="
        # 这里可以添加更多的输出内容
    } > "$output_file"
    print_success "结果已保存到: $output_file"
fi
