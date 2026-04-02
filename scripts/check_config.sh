#!/bin/bash

# ==========================================
# 脚本名称: check_my_config.sh
# 描述: 自动判断当前 macOS 系统 Shell 正在使用的主要配置文件
# 使用方法: source ./check_my_config.sh  (必须使用 source 运行)
# ==========================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. 检测当前 Shell 类型
CURRENT_SHELL=$(basename "$SHELL")

echo -e "${BLUE}=== macOS Shell 配置文件探测器 ===${NC}"
echo -e "当前系统默认 Shell: ${YELLOW}$SHELL${NC} ($CURRENT_SHELL)"
echo "----------------------------------"

# 2. 根据 Shell 类型进行动态探测
case "$CURRENT_SHELL" in
    zsh)
        echo -e "${GREEN}检测到 Zsh。正在模拟 Zsh 交互式 Shell 启动过程...${NC}"
        echo "我们将检查哪些文件存在，并应被加载。"
        echo ""

        # 检查 Zsh 核心文件
        ZSH_FILES=( ".zshenv" ".zprofile" ".zshrc" ".zlogin" )
        
        FOUND_ANY=false
        for file in "${ZSH_FILES[@]}"; do
            if [ -f "$HOME/$file" ]; then
                echo -e " [ ${GREEN}存在${NC} ] ~/$file"
                FOUND_ANY=true
                
                # 特殊说明 .zshrc
                if [ "$file" == ".zshrc" ]; then
                    echo -e "           ${YELLOW}--> 这是你绝大多数环境变量和 Alias 的存放地。${NC}"
                fi
            else
                echo -e " [ ${RED}缺失${NC} ] ~/$file"
            fi
        done

        echo ""
        if [ "$FOUND_ANY" = true ]; then
             echo -e "${GREEN}结论:${NC} 你的主要配置文件是 ${YELLOW}~/.zshrc${NC}。"
             echo "如果 ~/.zprofile 也存在，它通常在 ~./zshrc 之前加载一次。"
        else
             echo -e "${RED}警告:${NC} 未在用户主目录发现任何标准的 Zsh 配置文件。"
             echo "这通常意味着你在使用系统默认配置，或者你需要创建一个新的 ~/.zshrc。"
        fi
        ;;

    bash)
        echo -e "${GREEN}检测到 Bash。${NC}"
        echo "我们将检查常见的 Bash 启动文件。"
        echo ""

        # Bash 复杂在于加载顺序，通常只加载第一个找到的
        BASH_FILES=( ".bash_profile" ".bash_login" ".profile" ".bashrc" )
        
        PRINCIPAL=""
        for file in "${BASH_FILES[@]}"; do
            if [ -f "$HOME/$file" ]; then
                echo -e " [ ${GREEN}存在${NC} ] ~/$file"
                if [ -z "$PRINCIPAL" ] && [ "$file" != ".bashrc" ]; then
                    PRINCIPAL="~/$file"
                fi
            else
                echo -e " [ ${RED}缺失${NC} ] ~/$file"
            fi
        done

        echo ""
        if [ -n "$PRINCIPAL" ]; then
             echo -e "${GREEN}结论:${NC} 你的 Login Shell 主要配置文件是 ${YELLOW}$PRINCIPAL${NC}。"
             if [ -f "$HOME/.bashrc" ]; then
                echo -e "注意: ~/.bashrc 存在，通常由 $PRINCIPAL 主动 source 加载。"
             fi
        else
             if [ -f "$HOME/.bashrc" ]; then
                echo -e "${GREEN}结论:${NC} 你的主要配置文件是 ${YELLOW}~/.bashrc${NC}。"
             else
                echo -e "${RED}警告:${NC} 未在用户主目录发现任何标准的 Bash 配置文件。${NC}"
             fi
        fi
        ;;

    *)
        echo -e "${RED}抱歉，本脚本当前仅支持探测 Zsh 和 Bash。${NC}"
        echo "你正在使用: $CURRENT_SHELL"
        ;;
esac

echo "----------------------------------"
echo -e "${BLUE}探测结束。${NC}"
