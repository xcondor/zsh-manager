export type Language = 'en' | 'zh' | 'zh_Hant' | 'ko' | 'ja' | 'fr' | 'de' | 'fi' | 'ru';

export const translations: Record<Language, any> = {
  en: {
    common: {
      backToSite: "Back to Site",
      backToHome: "Back to Home",
      advanced: "Advanced",
    },
    nav: {
      features: "Features",
      pricing: "Pricing",
      security: "Security",
      faq: "FAQ",
      changelog: "Changelog",
      support: "Support",
      download: "Download"
    },
    pricing_page: {
      title: "Simple, Transparent Pricing",
      subtitle: "One-time payment. Lifetime access. No recurring subscriptions.",
      lifetime_license: "Lifetime License",
      lifetime_desc: "Everything you need to master your terminal.",
      forever: "forever",
      buy_now: "Get Started Now",
      guarantee: "Includes 30-day money back guarantee.",
      trusted_by: "Trusted by 10,000+ developers worldwide",
      safe_secure: "Safe & Secure",
      safe_desc: "Your data never leaves your device. iCloud sync is end-to-end encrypted.",
      money_back: "30-Day Money Back",
      money_desc: "If you're not satisfied, we'll refund your purchase within 30 days.",
      testimonial_text: "Zshrc Manager has completely transformed how I manage my terminal environment. The one-time payment was the best investment I've made for my dev setup.",
      testimonial_author: "Alex Rivera",
      testimonial_role: "Senior DevOps Engineer",
      features: [
        "Native macOS Application",
        "Visual Zshrc Editor",
        "iCloud Secure Sync",
        "Lifetime Updates",
        "Premium Support"
      ]
    },
    changelog_page: {
      title: "Changelog",
      new: "New",
      improved: "Improved",
      fixed: "Fixed"
    },
    contact_page: {
      title: "Contact Us",
      get_in_touch: "Get in Touch",
      get_in_touch_desc: "Whether you have a question about features, pricing, need technical support, or anything else, our team is ready to answer all your questions.",
      email_support: "Email Support",
      email_support_desc: "For general inquiries and technical support, please email us directly at:",
      response_time: "We aim to respond to all inquiries within 24 hours during regular business days.",
      business: "Business & Partnerships",
      business_desc: "For media inquiries, enterprise licensing, or partnership opportunities, please reach out to us at:"
    },
    hero: {
      badge: "Built natively for macOS",
      title: "The Ultimate macOS Companion for Zsh",
      subtitle: "Effortlessly manage, sync, and organize your zsh configurations",
      getStarted: "Get Started",
      learnMore: "Learn More"
    },
    features: {
      title: "Powerful Features",
      cards: [
        {
          title: "Python Smart Environment",
          desc: "Auto-activate virtual environments",
          highlights: ["Auto VENV", "PEP 668"]
        },
        {
          title: "Profile Switching",
          desc: "Instant configuration switching",
          highlights: ["Multi-Profile", "Fast Refresh"]
        },
        {
          title: "iCloud Sync",
          desc: "Seamless multi-device sync",
          highlights: ["Native Sync", "E2E Encrypted"]
        },
        {
          title: "Safe Editing",
          desc: "Built-in backups and rollback",
          highlights: ["Auto Backup", "Rollback"]
        }
      ]
    },
    pricing: {
      offer: "Lifetime Access",
      subtitle: "One-time purchase, no subscription",
      buy: "Buy Now",
      oneTime: "One-time payment",
      secure: "Secure checkout via Stripe • Instant activation",
      features: [
        "Lifetime updates",
        "Priority support",
        "All features included",
        "Future enhancements",
        "iCloud synchronization",
        "No recurring fees"
      ]
    },
    trust: {
      title: "Trusted by Developers",
      nonDestructive: {
        title: "Non-destructive",
        desc: "Safe configuration management that never breaks your setup."
      },
      icloudSecurity: {
        title: "iCloud Security",
        desc: "End-to-end encrypted cloud synchronization for your peace of mind."
      },
      badges: {
        native: "macOS Native",
        privacy: "Privacy First",
        openSource: "Open Source"
      }
    },
    docs_subpages: {
      install_title: "Installation",
      install_desc: "Zshrc Manager is distributed as a standard macOS DMG package.",
      install_req: "System Requirements",
      install_step1: "Step 1: Download",
      install_step1_desc: "Download the latest version of Zshrc Manager from the official website.",
      install_step2: "Drag to Applications",
      install_step2_desc: "Open the downloaded DMG and drag the Zshrc Manager icon into your Applications folder.",
      install_step3: "Step 3: Initial Setup",
      install_step3_desc: "Upon first launch, Zshrc Manager will perform a quick scan of your ~/.zshrc file. It will safely index your existing aliases and environment variables.",
      install_note: "Note: You may need to grant Full Disk Access to allow the application to modify configuration files in your home directory.",
      tm_title: "Terminal Master",
      tm_desc: "Instantly transform your terminal into a professional workstation. No manual configuration required.",
      tm_overview: "Visual Dashboard Overview",
      tm_deploy: "Deploy Oh My Zsh",
      tm_deploy_desc: "Oh My Zsh is the foundation of a modern terminal. With Zshrc Manager, you don't need to copy-paste install scripts. Simply click Install next to Oh My Zsh in the Core Components section.",
      tm_status: "Core Component Status",
      tm_ready: "READY",
      tm_feat1: "Automated Git Clone",
      tm_feat2: "Safe Config Backup",
      tm_feat3: "Instant Activation",
      cd_title: "Config Doctor",
      cd_desc: "Automatically detect and fix syntax errors, path conflicts, and duplicate aliases in your zshrc.",
      sync_title: "iCloud Sync (Pro)",
      sync_desc: "Keep your terminal environment perfectly synchronized across all your Macs.",
      snap_title: "Snapshots",
      snap_desc: "Create and restore backups of your entire zsh environment with a single click.",
      python_title: "Python Manager",
      python_desc: "Seamlessly manage Pyenv, Anaconda, and Poetry paths without breaking your shell.",
      manual_title: "Manual Configurations",
      manual_desc: "For advanced users: How to safely edit raw configuration blocks within Zshrc Manager.",
      install_brew: "Install via Homebrew",
      install_brew_desc: "The fastest way for power users to install Zshrc Manager using the command line.",
    },
    docs: {
      intro_title: "Introduction",
      intro_desc: "Zshrc Manager is the ultimate macOS desktop application designed to simplify your shell environment management. Whether you're a seasoned developer or just starting out, our tool provides a professional GUI to master Zsh.",
      gui_title: "GUI First",
      gui_desc: "No more editing hidden dotfiles in Vim. Manage everything via a beautiful Native macOS interface.",
      safe_title: "Safe & Reliable",
      safe_desc: "Every change is validated and backed up. One click restoration if anything goes wrong.",
      preview_title: "Visual Preview"
    },
    footer: {
      tagline: "Crafted for macOS Power Users",
      product: "Product",
      support: "Support",
      legal: "Legal",
      docs: "Documentation",
      contact: "Contact Us",
      changelog: "Changelog",
      refund: "Refund Policy",
      copyright: "© 2024 Zshrc Manager. All rights reserved.",
      links: ["Privacy Policy", "Terms of Service", "GitHub"]
    },
    cta: {
      title: "Ready to transform your Zsh experience?",
      subtitle: "Join 10,000+ developers who have mastered their terminal environment.",
      download: "Download Now",
      version: "Version 2.1.0",
      requires: "Requires macOS 12+"
    },
    socialProof: {
      count: "10,000+",
      label: "Downloads & counting"
    },
    faq: {
      title: "Frequently Asked Questions",
      subtitle: "Have more questions? Contact our support team.",
      items: [
        {
          q: "Is it safe to use with my existing .zshrc?",
          a: "Absolutely. Zshrc Manager uses a non-destructive approach by creating a dedicated environment while preserving your original configuration as a backup."
        },
        {
          q: "How does iCloud sync work?",
          a: "It leverages Apple's native iCloud Drive to securely sync your profiles, aliases, and environment variables across multiple Macs without any third-party servers."
        },
        {
          q: "What is the Python Smart Environment?",
          a: "It's a specialized tool that resolves the common PEP 668 'externally-managed-environment' errors by automatically setting up sandboxed environments for your projects."
        },
        {
          q: "Is it a subscription?",
          a: "No. Zshrc Manager is a one-time purchase for lifetime access, including all future updates and premium support."
        }
      ]
    },
    tech: {
      title: "Built for Your Workflow",
      subtitle: "Seamlessly integrates with the tools you already use every day"
    }
  },
  zh: {
    common: {
      backToSite: "返回首页",
      backToHome: "回主页",
      advanced: "高级功能",
    },
    nav: {
      features: "功能特性",
      pricing: "价格",
      security: "安全",
      faq: "常见问题",
      changelog: "更新日志",
      support: "支持",
      download: "开始下载"
    },
    pricing_page: {
      title: "简单透明的价格",
      subtitle: "一次性付款。终身访问。无重复订阅。",
      lifetime_license: "终身许可",
      lifetime_desc: "掌控终端所需的一切功能。",
      forever: "永久",
      buy_now: "立即开始",
      guarantee: "包含 30 天无理由退款保证。",
      trusted_by: "全球超过 10,000+ 名开发者的信任",
      safe_secure: "安全可靠",
      safe_desc: "您的数据永远不会离开您的设备。iCloud 同步经过端到端加密。",
      money_back: "30 天无理由退款",
      money_desc: "如果您不满意，我们将在 30 天内全额退款。",
      testimonial_text: "Zshrc Manager 彻底改变了我管理终端环境的方式。一次性付费是我为开发环境做出的最棒投资。",
      testimonial_author: "Alex Rivera",
      testimonial_role: "高级 DevOps 工程师",
      features: [
        "原生 macOS 应用程序",
        "可视化 Zshrc 编辑器",
        "iCloud 安全同步",
        "终身免费更新",
        "优先技术支持"
      ]
    },
    changelog_page: {
      title: "更新日志",
      new: "新增",
      improved: "优化",
      fixed: "修复"
    },
    contact_page: {
      title: "联系我们",
      get_in_touch: "保持联系",
      get_in_touch_desc: "无论您有关于功能、价格、技术支持或任何其他问题，我们的团队随时准备为您解答。",
      email_support: "邮件支持",
      email_support_desc: "有关一般查询和技术支持，请直接发送电子邮件至：",
      response_time: "我们的目标是在常规工作日的 24 小时内回复所有查询。",
      business: "业务与合作伙伴",
      business_desc: "有关媒体查询、企业许可或合作伙伴机会，请通过以下方式联系我们："
    },
    hero: {
      badge: "为 macOS 原生打造",
      title: "您的终端终极 macOS 伴侣",
      subtitle: "轻松管理、同步和组织您的 Zsh 配置环境",
      getStarted: "立即开始",
      learnMore: "了解更多"
    },
    features: {
      title: "强大功能",
      cards: [
        {
          title: "Python 智能环境",
          desc: "自动激活项目虚拟环境",
          highlights: ["自动 VENV", "PEP 668"]
        },
        {
          title: "配置切换",
          desc: "瞬间切换，即时生效",
          highlights: ["多维配置", "即时切换"]
        },
        {
          title: "iCloud 同步",
          desc: "跨设备无缝同步配置",
          highlights: ["原生同步", "加密传输"]
        },
        {
          title: "安全编辑",
          desc: "内置备份与版本回滚",
          highlights: ["自动备份", "版本历史"]
        }
      ]
    },
    pricing: {
      offer: "终身访问",
      subtitle: "一次性购买，无需订阅",
      buy: "立即购买",
      oneTime: "一次性付款",
      secure: "通过 Stripe 安全结算 • 立即激活",
      features: [
        "终身更新",
        "优先支持",
        "包含所有功能",
        "未来功能增强",
        "iCloud 同步",
        "无重复费用"
      ]
    },
    trust: {
      title: "开发者信赖",
      nonDestructive: {
        title: "非破坏性",
        desc: "安全的配置管理策略，绝不会破坏您的原始设置。"
      },
      icloudSecurity: {
        title: "iCloud 安全",
        desc: "端到端加密的云同步，为您提供安心保障。"
      },
      badges: {
        native: "macOS 原生",
        privacy: "隐私至上",
        openSource: "开源社区"
      }
    },
    docs_subpages: {
      install_title: "安装教程",
      install_desc: "Zshrc Manager 以标准的 macOS DMG 格式发布。",
      install_req: "系统要求",
      install_step1: "第一步：下载",
      install_step1_desc: "从官方网站下载最新版本的 Zshrc Manager。",
      install_step2: "拖拽到应用程序",
      install_step2_desc: "打开下载的 DMG 文件，将 Zshrc Manager 图标拖入 Applications 文件夹。",
      install_step3: "第三步：初始设置",
      install_step3_desc: "首次启动时，Zshrc Manager 将快速扫描您的 ~/.zshrc 文件，并安全地索引现有的别名和环境变量。",
      install_note: "注意：您可能需要授予“完全磁盘访问权限”，以允许应用程序修改主目录中的配置文件。",
      tm_title: "终端大师",
      tm_desc: "瞬间将您的终端转变为专业工作站，无需任何手动配置。",
      tm_overview: "可视化仪表盘概览",
      tm_deploy: "部署 Oh My Zsh",
      tm_deploy_desc: "Oh My Zsh 是现代终端的基础。有了 Zshrc Manager，您无需复制粘贴安装脚本。只需在核心组件部分点击 Oh My Zsh 旁边的“安装”即可。",
      tm_status: "核心组件状态",
      tm_ready: "已就绪",
      tm_feat1: "自动 Git 克隆",
      tm_feat2: "安全配置备份",
      tm_feat3: "即时激活",
      cd_title: "配置诊断",
      cd_desc: "自动检测并修复 zshrc 中的语法错误、路径冲突和重复别名。",
      sync_title: "iCloud 同步 (Pro)",
      sync_desc: "在您所有的 Mac 上保持终端环境完美同步。",
      snap_title: "环境快照",
      snap_desc: "一键创建和恢复整个 zsh 环境的备份。",
      python_title: "Python 管理",
      python_desc: "无缝管理 Pyenv、Anaconda 和 Poetry 路径，而不会破坏您的 shell。",
      manual_title: "手动配置",
      manual_desc: "针对高级用户：如何在 Zshrc Manager 中安全地编辑原始配置块。",
      install_brew: "通过 Homebrew 安装",
      install_brew_desc: "对于高级用户，使用命令行安装 Zshrc Manager 的最快方式。",
    },
    docs: {
      intro_title: "介绍",
      intro_desc: "Zshrc Manager 是终极 macOS 桌面应用，旨在简化您的终端环境管理。无论您是经验丰富的开发者还是初学者，我们的工具都提供专业的图形界面让您掌控 Zsh。",
      gui_title: "图形界面优先",
      gui_desc: "不再需要在 Vim 中编辑隐藏的配置文件。通过精美的原生 macOS 界面管理一切。",
      safe_title: "安全可靠",
      safe_desc: "每次更改都会经过验证和备份。如果出现任何问题，一键即可恢复。",
      preview_title: "视觉预览"
    },
    footer: {
      tagline: "为 macOS 高级用户精心打造",
      product: "产品",
      support: "支持",
      legal: "法律",
      docs: "帮助文档",
      contact: "联系我们",
      changelog: "更新日志",
      refund: "退款政策",
      copyright: "© 2024 Zshrc Manager. 保留所有权利。",
      links: ["隐私政策", "服务条款", "GitHub"]
    },
    cta: {
      title: "准备好提升您的 Zsh 体验了吗？",
      subtitle: "加入 10,000+ 已经掌控终端环境的开发者。",
      download: "立即下载",
      version: "版本 2.1.0",
      requires: "需要 macOS 12+"
    },
    socialProof: {
      count: "10,000+",
      label: "次下载量并持续增长"
    },
    faq: {
      title: "常见问题",
      subtitle: "还有其他问题吗？请联系我们的支持团队。",
      items: [
        {
          q: "使用它会破坏我现有的 .zshrc 吗？",
          a: "绝对不会。Zshrc Manager 采用非破坏性策略，它会创建一个独立的环境，同时将您的原始配置作为备份完整保留。"
        },
        {
          q: "iCloud 同步是如何工作的？",
          a: "它利用苹果原生的 iCloud Drive 技术，在多台 Mac 之间安全地同步您的配置文件、别名和环境变量，不经过任何第三方服务器。"
        },
        {
          q: "什么是 Python 智能环境？",
          a: "这是一个专门的工具，用于解决常见的 PEP 668 '外部管理环境' 错误，通过为您的项目自动设置沙盒环境来解决冲突。"
        },
        {
          q: "这是订阅制吗？",
          a: "不是。Zshrc Manager 是终身访问的一次性购买，包含所有未来的更新和优先技术支持。"
        }
      ]
    },
    tech: {
      title: "为您所需的工作流而建",
      subtitle: "与您日常使用的开发工具无缝集成"
    }
  },
  zh_Hant: {
    common: {
      backToSite: "返回首頁",
      backToHome: "回主頁",
      advanced: "高級功能",
    },
    nav: {
      features: "功能特性",
      pricing: "價格",
      security: "安全",
      faq: "常見問題",
      changelog: "更新日誌",
      support: "支持",
      download: "開始下載"
    },
    hero: {
      badge: "為 macOS 原生打造",
      title: "您的終端終極 macOS 伴侶",
      subtitle: "輕鬆管理、同步和組織您的 Zsh 配置環境",
      getStarted: "立即開始",
      learnMore: "了解更多"
    },
    features: {
      title: "強大功能",
      cards: [
        {
          title: "配置管理",
          desc: "輕鬆創建、編輯和組織多個 Zsh 配置。"
        },
        {
          title: "配置切換",
          desc: "根據您的工作流即時切換不同的配置文件。"
        },
        {
          title: "iCloud 同步",
          desc: "在您的所有設備之間無縫同步配置資產。"
        },
        {
          title: "非破壞性編輯",
          desc: "內置備份與版本歷史，確保配置編輯安全無憂。"
        }
      ]
    },
    pricing_page: {
      title: "簡單透明的價格",
      subtitle: "一次性付款。終身訪問。無重複訂閱。",
      lifetime_license: "終身許可",
      lifetime_desc: "掌控終端所需的一切功能。",
      forever: "永久",
      buy_now: "立即開始",
      guarantee: "包含 30 天無理由退款保證。",
      trusted_by: "全球超過 10,000+ 名開發者的信任",
      safe_secure: "安全可靠",
      safe_desc: "您的數據永遠不會離開您的設備。iCloud 同步經過端到端加密。",
      money_back: "30 天無理由退款",
      money_desc: "如果您不滿意，我們將在 30 天內全額退款。",
      testimonial_text: "Zshrc Manager 徹底改變了我管理終端環境的方式。一次性付費是我為開發環境做出的最棒投資。",
      testimonial_author: "Alex Rivera",
      testimonial_role: "高級 DevOps 工程師",
      features: [
        "原生 macOS 應用程式",
        "視覺化 Zshrc 編輯器",
        "iCloud 安全同步",
        "終身免費更新",
        "優先技術支持"
      ]
    },
    trust: {
      title: "開發者信賴",
      nonDestructive: {
        title: "非破壞性",
        desc: "安全的配置管理策略，絕不會破壞您的原始設置。"
      },
      icloudSecurity: {
        title: "iCloud 安全",
        desc: "端到端加密的雲同步，為您提供安心保障。"
      },
      badges: {
        native: "macOS 原生",
        privacy: "隱私至上",
        openSource: "開源社區"
      }
    },
    docs_subpages: {
      install_title: "安裝教學",
      install_desc: "Zshrc Manager 以標準的 macOS DMG 格式發布。",
      install_req: "系統要求",
      install_step1: "第一步：下載",
      install_step1_desc: "從官方網站下載最新版本的 Zshrc Manager。",
      install_step2: "拖曳到應用程式",
      install_step2_desc: "打開下載的 DMG 檔案，將 Zshrc Manager 圖標拖入 Applications 資料夾。",
      install_step3: "第三步：初始設置",
      install_step3_desc: "首次啟動時，Zshrc Manager 將快速掃描您的 ~/.zshrc 檔案，並安全地索引現有的別名和環境變數。",
      install_note: "注意：您可能需要授予「完全磁碟存取權限」，以允許應用程式修改主目錄中的設定檔。",
      tm_title: "終端大師",
      tm_desc: "瞬間將您的終端轉變為專業工作站，無需任何手動設定。",
      tm_overview: "視覺化儀表板概覽",
      tm_deploy: "部署 Oh My Zsh",
      tm_deploy_desc: "Oh My Zsh 是現代終端的基礎。有了 Zshrc Manager，您無需複製貼上安裝腳本。只需在核心組件部分點擊 Oh My Zsh 旁邊的「安裝」即可。",
      cd_title: "配置診斷",
      cd_desc: "自動檢測並修復 zshrc 中的語法錯誤、路徑衝突和重複別名。",
      sync_title: "iCloud 同步 (Pro)",
      sync_desc: "在您所有的 Mac 上保持終端環境完美同步。",
      snap_title: "環境快照",
      snap_desc: "一鍵創建和恢復整個 zsh 環境的備份。",
      python_title: "Python 管理",
      python_desc: "無縫管理 Pyenv、Anaconda 和 Poetry 路徑，而不會破壞您的 shell。",
      manual_title: "手動配置",
      manual_desc: "針對高級用戶：如何在 Zshrc Manager 中安全地編輯原始配置區塊。",
      install_brew: "透過 Homebrew 安裝",
      install_brew_desc: "對於高級用戶，使用命令行安裝 Zshrc Manager 的最快方式。",
    },
    docs: {
      intro_title: "介紹",
      intro_desc: "Zshrc Manager 是終極 macOS 桌面應用，旨在簡化您的終端環境管理。無論您是經驗豐富的開發者還是初學者，我們的工具都提供專業的圖形界面讓您掌控 Zsh。",
      gui_title: "圖形界面優先",
      gui_desc: "不再需要在 Vim 中編輯隱藏的配置文件。透過精美的原生 macOS 界面管理一切。",
      safe_title: "安全可靠",
      safe_desc: "每次更改都會經過驗證和備份。如果出現任何問題，一鍵即可恢復。",
      preview_title: "視覺預覽"
    },
    footer: {
      tagline: "為 macOS 高級用戶精心打造",
      product: "產品",
      support: "支援",
      legal: "法律",
      docs: "說明文件",
      contact: "聯絡我們",
      changelog: "更新日誌",
      refund: "退款政策",
      copyright: "© 2024 Zshrc Manager. 保留所有權利。",
      links: ["隱私政策", "服務條款", "GitHub"]
    },
    cta: {
      title: "準備好提升您的 Zsh 體驗了嗎？",
      subtitle: "加入 10,000+ 已經掌控終端環境的開發者。",
      download: "立即下載",
      version: "版本 2.1.0",
      requires: "需要 macOS 12+"
    },
    socialProof: {
      count: "10,000+",
      label: "次下載量並持續增長"
    },
    faq: {
      title: "常見問題",
      subtitle: "還有其他問題嗎？請聯繫我們的支持團隊。",
      items: [
        {
          q: "使用它會破壞我現有的 .zshrc 嗎？",
          a: "絕對不會。Zshrc Manager 採用非破壞性策略，它會創建一個獨立的環境，同時將您的原始配置作為備份完整保留。"
        },
        {
          q: "iCloud 同步是如何工作的？",
          a: "它利用蘋果原生的 iCloud Drive 技術，在多台 Mac 之間安全地同步您的配置文件、別名和环境变量，不經過任何第三方服務器。"
        }
      ]
    },
    tech: {
      title: "為您所需的工作流而建",
      subtitle: "與您日常使用的開發工具無縫集成"
    }
  },
  ko: {
    common: {
      backToSite: "사이트로 돌아가기",
      backToHome: "홈으로 돌아가기",
      advanced: "고급 설정",
    },
    nav: {
      features: "기능",
      pricing: "가격",
      security: "보안",
      faq: "자주 묻는 질문",
      changelog: "업데이트 로그",
      support: "지원",
      download: "다운로드"
    },
    hero: {
      badge: "macOS용 네이티브 앱",
      title: "터미널을 위한 최고의 macOS 동반자",
      subtitle: "Zsh 구성을 손쉽게 관리, 동기화 및 구성하세요",
      getStarted: "시작하기",
      learnMore: "더 알아보기"
    },
    features: {
      title: "강력한 기능",
      cards: [
        {
          title: "구성 관리",
          desc: "여러 Zsh 구성을 쉽게 생성, 편집 및 구성할 수 있습니다."
        },
        {
          title: "프로필 전환",
          desc: "워크플로우에 맞춰 프로필을 즉시 전환하세요."
        },
        {
          title: "iCloud 동기화",
          desc: "모든 기기에서 구성을 원활하게 동기화하세요."
        },
        {
          title: "비파괴 편집",
          desc: "백업 및 버전 기록이 포함된 안전한 편집."
        },
        {
          title: "Python 스크립트 지원",
          desc: "Python 기반의 스크립트로 터미널 설정을 자동화하세요."
        }
      ]
    },
    pricing_page: {
      title: "단순하고 투명한 가격",
      subtitle: "일회성 결제. 평생 이용. 반복 구독 없음.",
      lifetime_license: "평생 라이선스",
      lifetime_desc: "터미널을 마스터하는 데 필요한 모든 것.",
      forever: "평생",
      buy_now: "지금 시작하기",
      guarantee: "30일 환불 보증 포함.",
      trusted_by: "전 세계 10,000명 이상의 개발자가 신뢰함",
      safe_secure: "안전 및 보안",
      safe_desc: "데이터는 장치를 떠나지 않습니다. iCloud 동기화는 종단간 암호화됩니다.",
      money_back: "30일 환불",
      money_desc: "만족하지 못할 경우 30일 이내에 환불해 드립니다.",
      testimonial_text: "Zshrc Manager는 터미널 환경 관리 방식을 완전히 바꾸어 놓았습니다. 일회성 결제는 제 개발 환경을 위한 최고의 투자였습니다.",
      testimonial_author: "Alex Rivera",
      testimonial_role: "시니어 DevOps 엔지니어",
      features: [
        "네이티브 macOS 애플리케이션",
        "비주얼 Zshrc 에디터",
        "iCloud 보안 동기화",
        "평생 업데이트",
        "프리미엄 지원"
      ]
    },
    trust: {
      title: "개발자들이 신뢰하는 도구",
      nonDestructive: {
        title: "비파괴 관리",
        desc: "기존 설정을 깨뜨리지 않는 안전한 구성 관리."
      },
      icloudSecurity: {
        title: "iCloud 보안",
        desc: "안심할 수 있는 종단간 암호화 클라우드 동기화."
      },
      badges: {
        native: "macOS 네이티브",
        privacy: "개인정보 보호",
        openSource: "오픈 소스"
      }
    },
    docs_subpages: {
      install_title: "설치",
      install_desc: "Zshrc Manager는 표준 macOS DMG 패키지로 배포됩니다.",
      install_req: "시스템 요구 사항",
      install_step1: "1단계: 다운로드",
      install_step1_desc: "공식 웹사이트에서 Zshrc Manager의 최신 버전을 다운로드하십시오.",
      install_step2: "응용 프로그램으로 드래그",
      install_step2_desc: "다운로드한 DMG를 열고 Zshrc Manager 아이콘을 응용 프로그램 폴더로 드래그합니다.",
      install_step3: "3단계: 초기 설정",
      install_step3_desc: "첫 실행 시 Zshrc Manager는 ~/.zshrc 파일을 스캔합니다.",
      install_note: "참고: 전체 디스크 접근 권한을 부여해야 할 수 있습니다.",
      tm_title: "터미널 마스터",
      tm_desc: "수동 구성 없이 터미널을 전문 워크스테이션으로 즉시 변환합니다.",
      tm_overview: "대시보드 개요",
      tm_deploy: "Oh My Zsh 배포",
      tm_deploy_desc: "Zshrc Manager를 사용하면 설치 스크립트를 복사하여 붙여넣을 필요가 없습니다.",
      cd_title: "구성 닥터",
      cd_desc: "구문 오류 및 경로 충돌을 자동으로 수정합니다.",
      sync_title: "iCloud 동기화 (Pro)",
      sync_desc: "모든 Mac에서 터미널 환경을 완벽하게 동기화합니다.",
      snap_title: "스냅샷",
      snap_desc: "클릭 한 번으로 전체 Zsh 환경의 백업을 생성합니다.",
      python_title: "Python 관리자",
      python_desc: "Pyenv, Anaconda, Poetry 경로를 원활하게 관리합니다.",
      manual_title: "수동 구성",
      manual_desc: "Zshrc Manager에서 원시 구성 블록을 안전하게 편집하는 방법.",
      install_brew: "Homebrew를 통해 설치",
      install_brew_desc: "파워 유저가 명령줄을 사용하여 Zshrc Manager를 설치하는 가장 빠른 방법입니다.",
    },
    docs: {
      intro_title: "소개",
      intro_desc: "Zshrc Manager는 셸 환경 관리를 간소화하도록 설계된 궁극의 macOS 데스크톱 애플리케이션입니다. 경험이 풍부한 개발자든 초보자든, 우리의 도구는 Zsh를 마스터하기 위한 전문적인 GUI를 제공합니다.",
      gui_title: "GUI 우선",
      gui_desc: "더 이상 Vim에서 숨겨진 구성 파일을 편집할 필요가 없습니다. 아름다운 네이티브 macOS 인터페이스를 통해 모든 것을 관리하세요.",
      safe_title: "안전하고 신뢰할 수 있음",
      safe_desc: "모든 변경 사항은 검증되고 백업됩니다. 문제가 발생하면 원클릭으로 복원할 수 있습니다.",
      preview_title: "시각적 미리보기"
    },
    footer: {
      tagline: "macOS 파워 유저를 위해 제작됨",
      product: "제품",
      support: "지원",
      legal: "법률",
      docs: "문서",
      contact: "문의하기",
      changelog: "변경 내역",
      refund: "환불 정책",
      copyright: "© 2024 Zshrc Manager. 모든 권리 보유.",
      links: ["개인정보 처리방침", "서비스 약관", "GitHub"]
    },
    cta: {
      title: "Zsh 경험을 변화시킬 준비가 되셨나요?",
      subtitle: "터미널 환경을 마스터한 10,000명 이상의 개발자와 함께하세요.",
      download: "지금 다운로드",
      version: "버전 2.1.0",
      requires: "macOS 12 이상 필요"
    },
    socialProof: {
      count: "10,000+",
      label: "다운로드 및 증가 중"
    },
    faq: {
      title: "자주 묻는 질문",
      items: [
        {
          q: "기존 .zshrc 파일이 손상되나요?",
          a: "아니요. Zshrc Manager는 비파괴적 접근 방식을 사용하여 기존 구성을 백업으로 보존하면서 전용 환경을 만듭니다."
        }
      ]
    },
    tech: {
      title: "당신의 워크플로우를 위해 제작되었습니다",
      subtitle: "매일 사용하는 도구와 원활하게 통합됩니다"
    }
  },
  ja: {
    common: {
      backToSite: "サイトに戻る",
      backToHome: "ホームに戻る",
      advanced: "高度な設定",
    },
    nav: {
      features: "機能",
      pricing: "価格",
      security: "セキュリティ",
      faq: "よくある質問",
      changelog: "更新履歴",
      support: "サポート",
      download: "ダウンロード"
    },
    hero: {
      badge: "macOS向けネイティブ設計",
      title: "究極のmacOS向けZshコンパニオン",
      subtitle: "Zsh構成の管理、同期、整理を簡単に",
      getStarted: "今すぐ始める",
      learnMore: "詳しく見る"
    },
    features: {
      title: "強力な機能",
      cards: [
        {
          title: "構成管理",
          desc: "複数のZsh構成を簡単に作成、編集、整理できます。"
        },
        {
          title: "プロファイル切り替え",
          desc: "ワークフローに合わせて瞬時にプロファイルを切り替えられます。"
        },
        {
          title: "iCloud同期",
          desc: "すべてのデバイス間で構成をシームレスに同期できます。"
        },
        {
          title: "非破壊編集",
          desc: "バックアップと履歴機能を備えた安全な編集環境。"
        }
      ]
    },
    pricing_page: {
      title: "シンプルで透明な価格設定",
      subtitle: "一度の支払いで一生使い続けられます。サブスクリプションは不要です。",
      lifetime_license: "永久ライセンス",
      lifetime_desc: "ターミナルをマスターするために必要なすべてがここに。",
      forever: "永久",
      buy_now: "今すぐ始める",
      guarantee: "30日間の返金保証付き。",
      trusted_by: "世界中の10,000人以上の開発者に信頼されています",
      safe_secure: "安心・安全",
      safe_desc: "データがデバイスから離れることはありません。iCloud同期はエンドツーエンドで暗号化されます。",
      money_back: "30日間返金保証",
      money_desc: "ご満足いただけない場合は、30日以内に全額返金いたします。",
      testimonial_text: "Zshrc Manager は、ターミナル環境の管理方法を完全に変えてくれました。一度の支払いで一生使えるのは、開発環境への最高の投資でした。",
      testimonial_author: "Alex Rivera",
      testimonial_role: "シニア DevOps エンジニア",
      features: [
        "ネイティブ macOS アプリケーション",
        "ビジュアル Zshrc エディタ",
        "iCloud 安全同期",
        "永久アップデート",
        "プレミアムサポート"
      ]
    },
    trust: {
      title: "開発者に選ばれる理由",
      nonDestructive: {
        title: "非破壊管理",
        desc: "既存の環境を壊さない安全な構成管理戦略。"
      },
      icloudSecurity: {
        title: "iCloudセキュリティ",
        desc: "エンドツーエンド暗号化による安心のクラウド同期。"
      },
      badges: {
        native: "macOSネイティブ",
        privacy: "プライバシー重視",
        openSource: "オープンソース"
      }
    },
    docs_subpages: {
      install_title: "インストール",
      install_desc: "Zshrc Managerは標準のmacOS DMGパッケージとして配布されています。",
      install_req: "システム要件",
      install_step1: "ステップ1: ダウンロード",
      install_step1_desc: "公式サイトからZshrc Managerの最新バージョンをダウンロードしてください。",
      install_step2: "アプリケーションにドラッグ",
      install_step2_desc: "ダウンロードしたDMGを開き、Zshrc Managerアイコンをアプリケーションフォルダにドラッグします。",
      install_step3: "ステップ3: 初期設定",
      install_step3_desc: "初回起動時、Zshrc Managerは~/.zshrcファイルをスキャンします。",
      install_note: "注：フルディスクアクセスを許可する必要があります。",
      tm_title: "ターミナルマスター",
      tm_desc: "手動設定なしでターミナルをプロのワークステーションに変換します。",
      tm_overview: "ダッシュボードの概要",
      tm_deploy: "Oh My Zshを展開",
      tm_deploy_desc: "Zshrc Managerを使えばインストールスクリプトをコピペする必要はありません。",
      cd_title: "構成ドクター",
      cd_desc: "構文エラーやパスの競合を自動的に修正します。",
      sync_title: "iCloud 同期 (Pro)",
      sync_desc: "すべてのMacでターミナル環境を完全に同期します。",
      snap_title: "スナップショット",
      snap_desc: "Zsh環境全体のバックアップをワンクリックで作成します。",
      python_title: "Pythonマネージャー",
      python_desc: "Pyenv、Anaconda、Poetryのパスをシームレスに管理します。",
      manual_title: "手動設定",
      manual_desc: "Zshrc Managerで生の構成ブロックを安全に編集する方法。",
      install_brew: "Homebrew でインストール",
      install_brew_desc: "パワーユーザーがコマンドラインを使用して Zshrc Manager をインストールする最速の方法です。",
    },
    docs: {
      intro_title: "はじめに",
      intro_desc: "Zshrc Manager は、シェル環境の管理を簡素化するために設計された究極の macOS デスクトップアプリケーションです。経験豊富な開発者でも初心者でも、私たちのツールは Zsh をマスターするためのプロフェッショナルな GUI を提供します。",
      gui_title: "GUI ファースト",
      gui_desc: "Vim で隠し設定ファイルを編集する必要はもうありません。美しいネイティブ macOS インターフェースですべてを管理します。",
      safe_title: "安全で信頼性が高い",
      safe_desc: "すべての変更は検証され、バックアップされます。何か問題が発生した場合はワンクリックで復元できます。",
      preview_title: "ビジュアルプレビュー"
    },
    footer: {
      tagline: "macOSパワーユーザー向けに設計",
      product: "製品",
      support: "サポート",
      legal: "法的情報",
      docs: "ドキュメント",
      contact: "お問い合わせ",
      changelog: "更新履歴",
      refund: "返金ポリシー",
      copyright: "© 2024 Zshrc Manager. 無断複写・転載を禁じます。",
      links: ["プライバシーポリシー", "利用規約", "GitHub"]
    },
    cta: {
      title: "Zshの体験を変える準備はできましたか？",
      subtitle: "ターミナル環境をマスターした10,000人以上の開発者の仲間入りをしましょう。",
      download: "今すぐダウンロード",
      version: "バージョン 2.1.0",
      requires: "macOS 12以降が必要"
    },
    socialProof: {
      count: "10,000+",
      label: "ダウンロード数と増加中"
    },
    faq: {
      title: "よくある質問",
      items: [
        {
          q: "既存の .zshrc を壊すことはありますか？",
          a: "いいえ。Zshrc Manager は非破壊的なアプローチを採用しており、元の設定をバックアップとして保存しながら専用の環境を作成します。"
        }
      ]
    },
    tech: {
      title: "あなたのワークフローのために",
      subtitle: "毎日使うツールとシームレスに統合します"
    }
  },
  fr: {
    common: {
      backToSite: "Retour au site",
      backToHome: "Retour à l'accueil",
      advanced: "Avancé",
    },
    nav: {
      features: "Fonctionnalités",
      pricing: "Prix",
      security: "Sécurité",
      faq: "FAQ",
      changelog: "Changements",
      support: "Support",
      download: "Télécharger"
    },
    hero: {
      badge: "Natif pour macOS",
      title: "Le compagnon macOS ultime pour Zsh",
      subtitle: "Gérez, synchronisez et organisez vos configurations Zsh sans effort",
      getStarted: "Commencer",
      learnMore: "En savoir plus"
    },
    features: {
      title: "Fonctionnalités Puissantes",
      cards: [
        {
          title: "Gestion de Config",
          desc: "Créez, éditez et organisez plusieurs configurations Zsh avec facilité."
        },
        {
          title: "Changement de Profil",
          desc: "Basculez entre les profils instantanément."
        },
        {
          title: "Synchro iCloud",
          desc: "Synchronisez vos configurations sur tous vos appareils."
        },
        {
          title: "Édition Non-destructive",
          desc: "Édition sécurisée avec sauvegardes."
        }
      ]
    },
    pricing_page: {
      title: "Tarification Simple et Transparente",
      subtitle: "Paiement unique. Accès à vie. Pas d'abonnement récurrent.",
      lifetime_license: "Licence à Vie",
      lifetime_desc: "Tout ce dont vous avez besoin pour maîtriser votre terminal.",
      forever: "à vie",
      buy_now: "Commencer Maintenant",
      guarantee: "Garantie de remboursement de 30 jours incluse.",
      trusted_by: "Approuvé par plus de 10 000 développeurs dans le monde",
      safe_secure: "Sûr et Sécurisé",
      safe_desc: "Vos données ne quittent jamais votre appareil. La synchro iCloud est cryptée.",
      money_back: "30 Jours Satisfait ou Remboursé",
      money_desc: "Si vous n'êtes pas satisfait, nous vous remboursons dans les 30 jours.",
      testimonial_text: "Zshrc Manager a complètement transformé ma façon de gérer mon environnement de terminal. Le paiement unique a été le meilleur investissement pour mon setup dev.",
      testimonial_author: "Alex Rivera",
      testimonial_role: "Ingénieur DevOps Senior",
      features: [
        "Application Native macOS",
        "Éditeur Visuel Zshrc",
        "Synchro Sécurisée iCloud",
        "Mises à jour à Vie",
        "Support Premium"
      ]
    },
    trust: {
      title: "Approuvé par les Développeurs",
      nonDestructive: {
        title: "Non-destructif",
        desc: "Gestion de config sécurisée qui ne casse jamais votre setup."
      },
      icloudSecurity: {
        title: "Sécurité iCloud",
        desc: "Synchro cloud cryptée de bout en bout pour votre tranquillité."
      },
      badges: {
        native: "Natif macOS",
        privacy: "Vie Privée",
        openSource: "Open Source"
      }
    },
    docs_subpages: {
      install_title: "Installation",
      install_desc: "Zshrc Manager est distribué sous forme de package DMG macOS standard.",
      install_req: "Configuration requise",
      install_step1: "Étape 1: Télécharger",
      install_step1_desc: "Téléchargez la dernière version depuis le site officiel.",
      install_step2: "Faites glisser vers Applications",
      install_step2_desc: "Ouvrez le DMG et faites glisser l'icône dans le dossier Applications.",
      install_step3: "Étape 3: Configuration initiale",
      install_step3_desc: "Au premier lancement, Zshrc Manager analysera votre fichier ~/.zshrc.",
      install_note: "Remarque : un accès complet au disque peut être nécessaire.",
      tm_title: "Maître du terminal",
      tm_desc: "Transformez instantanément votre terminal en station de travail.",
      tm_overview: "Aperçu du tableau de bord",
      tm_deploy: "Déployer Oh My Zsh",
      tm_deploy_desc: "Plus besoin de copier-coller des scripts d'installation.",
      cd_title: "Docteur de configuration",
      cd_desc: "Corrigez automatiquement les erreurs de syntaxe et les conflits de chemin.",
      sync_title: "Synchronisation iCloud (Pro)",
      sync_desc: "Gardez votre environnement synchronisé sur tous vos Mac.",
      snap_title: "Instantanés",
      snap_desc: "Créez des sauvegardes de votre environnement Zsh en un clic.",
      python_title: "Gestionnaire Python",
      python_desc: "Gérez les chemins Pyenv, Anaconda et Poetry sans problème.",
      manual_title: "Configurations manuelles",
      manual_desc: "Comment modifier en toute sécurité les blocs de configuration bruts.",
      install_brew: "Installer via Homebrew",
      install_brew_desc: "Le moyen le plus rapide pour les utilisateurs avancés d'installer Zshrc Manager via la ligne de commande.",
    },
    docs: {
      intro_title: "Introduction",
      intro_desc: "Zshrc Manager est l'application de bureau macOS ultime conçue pour simplifier la gestion de votre environnement shell. Que vous soyez un développeur expérimenté ou débutant, notre outil offre une interface graphique professionnelle pour maîtriser Zsh.",
      gui_title: "Priorité à l'interface graphique",
      gui_desc: "Plus besoin d'éditer des fichiers de configuration cachés dans Vim. Gérez tout via une belle interface macOS native.",
      safe_title: "Sûr et fiable",
      safe_desc: "Chaque modification est validée et sauvegardée. Restauration en un clic en cas de problème.",
      preview_title: "Aperçu visuel"
    },
    footer: {
      tagline: "Conçu pour les utilisateurs avancés de macOS",
      product: "Produit",
      support: "Support",
      legal: "Légal",
      docs: "Documentation",
      contact: "Nous contacter",
      changelog: "Journal des modifications",
      refund: "Politique de remboursement",
      copyright: "© 2024 Zshrc Manager. Tous droits réservés.",
      links: ["Politique de Confidentialité", "Conditions", "GitHub"]
    },
    cta: {
      title: "Prêt à transformer votre expérience Zsh ?",
      subtitle: "Rejoignez plus de 10 000 développeurs qui maîtrisent leur terminal.",
      download: "Télécharger maintenant",
      version: "Version 2.1.0",
      requires: "Requis macOS 12+"
    },
    socialProof: {
      count: "10,000+",
      label: "téléchargements et ça continue"
    },
    faq: {
      title: "Questions Fréquemment Posées",
      items: [
        {
          q: "Est-ce sûr pour mon .zshrc existant ?",
          a: "Absolument. Zshrc Manager utilise une approche non destructive en créant un environnement dédié tout en préservant votre configuration d'origine."
        }
      ]
    },
    tech: {
      title: "Conçu pour votre flux de travail",
      subtitle: "S'intègre parfaitement aux outils que vous utilisez déjà"
    }
  },
  de: {
    common: {
      backToSite: "Zurück zur Website",
      backToHome: "Zurück zur Startseite",
      advanced: "Erweitert",
    },
    nav: {
      features: "Funktionen",
      pricing: "Preise",
      security: "Sicherheit",
      faq: "FAQ",
      changelog: "Changelog",
      support: "Support",
      download: "Download"
    },
    hero: {
      badge: "Nativ für macOS entwickelt",
      title: "Der ultimative macOS-Begleiter für Zsh",
      subtitle: "Verwalten, synchronisieren und organisieren Sie Ihre Zsh-Konfigurationen mühelos",
      getStarted: "Loslegen",
      learnMore: "Mehr erfahren"
    },
    features: {
      title: "Leistungsstarke Funktionen",
      cards: [
        {
          title: "Konfig-Management",
          desc: "Erstellen, bearbeiten und organisieren Sie mehrere Zsh-Konfigurationen mit Leichtigkeit."
        },
        {
          title: "Profil-Wechsel",
          desc: "Wechseln Sie Profile sofort passend zu Ihrem Workflow."
        },
        {
          title: "iCloud-Sync",
          desc: "Synchronisieren Sie Ihre Konfigurationen nahtlos auf all Ihren Geräten."
        },
        {
          title: "Sicheres Editieren",
          desc: "Gefahrloses Bearbeiten mit integrierten Backups und Versionsverlauf."
        }
      ]
    },
    pricing_page: {
      title: "Einfache, transparente Preise",
      subtitle: "Einmalzahlung. Lebenslanger Zugriff. Kein Abo.",
      lifetime_license: "Lebenslange Lizenz",
      lifetime_desc: "Alles, was Sie zur Beherrschung Ihres Terminals benötigen.",
      forever: "auf Lebenszeit",
      buy_now: "Jetzt loslegen",
      guarantee: "Inklusive 30-Tage-Geld-zurück-Garantie.",
      trusted_by: "Von über 10.000 Entwicklern weltweit geschätzt",
      safe_secure: "Sicher & Geschützt",
      safe_desc: "Ihre Daten verlassen niemals Ihr Gerät. iCloud-Sync ist Ende-zu-Ende verschlüsselt.",
      money_back: "30 Tage Geld-zurück",
      money_desc: "Wenn Sie nicht zufrieden sind, erstatten wir den Kaufpreis innerhalb von 30 Tagen.",
      testimonial_text: "Zshrc Manager hat die Art und Weise, wie ich meine Terminal-Umgebung verwalte, komplett verändert. Die Einmalzahlung war die beste Investition in mein Dev-Setup.",
      testimonial_author: "Alex Rivera",
      testimonial_role: "Senior DevOps Engineer",
      features: [
        "Native macOS Anwendung",
        "Visueller Zshrc-Editor",
        "Sicherer iCloud-Sync",
        "Lebenslange Updates",
        "Premium-Support"
      ]
    },
    trust: {
      title: "Von Entwicklern geschätzt",
      nonDestructive: {
        title: "Zerstörungsfrei",
        desc: "Sicheres Management, das Ihr Setup niemals beschädigt."
      },
      icloudSecurity: {
        title: "iCloud-Sicherheit",
        desc: "Ende-zu-Ende verschlüsselte Cloud-Synchronisation."
      },
      badges: {
        native: "macOS Nativ",
        privacy: "Datenschutz First",
        openSource: "Open Source"
      }
    },
    docs_subpages: {
      install_title: "Installation",
      install_desc: "Zshrc Manager wird als macOS-DMG verteilt.",
      install_req: "Systemanforderungen",
      install_step1: "Schritt 1: Herunterladen",
      install_step1_desc: "Laden Sie die neueste Version herunter.",
      install_step2: "In Anwendungen ziehen",
      install_step2_desc: "Ziehen Sie das Symbol in den Ordner Programme.",
      install_step3: "Schritt 3: Ersteinrichtung",
      install_step3_desc: "Zshrc Manager scannt Ihre ~/.zshrc-Datei.",
      install_note: "Hinweis: Möglicherweise müssen Sie Festplattenvollzugriff gewähren.",
      tm_title: "Terminal-Meister",
      tm_desc: "Verwandeln Sie Ihr Terminal sofort in eine Workstation.",
      tm_overview: "Dashboard-Übersicht",
      tm_deploy: "Oh My Zsh bereitstellen",
      tm_deploy_desc: "Kein Kopieren und Einfügen von Installationsskripten mehr.",
      cd_title: "Konfigurationsdoktor",
      cd_desc: "Syntaxfehler und Pfadkonflikte automatisch beheben.",
      sync_title: "iCloud-Synchronisierung (Pro)",
      sync_desc: "Halten Sie Ihre Umgebung auf allen Macs synchron.",
      snap_title: "Schnappschüsse",
      snap_desc: "Erstellen Sie mit einem Klick Backups Ihrer Zsh-Umgebung.",
      python_title: "Python-Manager",
      python_desc: "Verwalten Sie Pyenv, Anaconda und Poetry nahtlos.",
      manual_title: "Manuelle Konfigurationen",
      manual_desc: "So bearbeiten Sie Rohkonfigurationsblöcke sicher.",
      install_brew: "Über Homebrew installieren",
      install_brew_desc: "Der schnellste Weg für Power-User, Zshrc Manager über die Kommandozeile zu installieren.",
    },
    docs: {
      intro_title: "Einführung",
      intro_desc: "Zshrc Manager ist die ultimative macOS-Desktop-Anwendung zur Vereinfachung Ihrer Shell-Umgebungsverwaltung. Egal, ob Sie ein erfahrener Entwickler sind oder gerade erst anfangen, unser Tool bietet eine professionelle GUI, um Zsh zu meistern.",
      gui_title: "GUI zuerst",
      gui_desc: "Kein Bearbeiten versteckter Konfigurationsdateien mehr in Vim. Verwalten Sie alles über eine schöne native macOS-Schnittstelle.",
      safe_title: "Sicher & Zuverlässig",
      safe_desc: "Jede Änderung wird validiert und gesichert. Ein-Klick-Wiederherstellung, falls etwas schief geht.",
      preview_title: "Visuelle Vorschau"
    },
    footer: {
      tagline: "Entwickelt für macOS Power-User",
      product: "Produkt",
      support: "Support",
      legal: "Rechtliches",
      docs: "Dokumentation",
      contact: "Kontaktiere uns",
      changelog: "Änderungsprotokoll",
      refund: "Rückerstattungsrichtlinie",
      copyright: "© 2024 Zshrc Manager. Alle Rechte vorbehalten.",
      links: ["Datenschutz", "AGB", "GitHub"]
    },
    cta: {
      title: "Bereit, Ihr Zsh-Erlebnis zu transformieren?",
      subtitle: "Schließen Sie sich über 10.000 Entwicklern an, die ihr Terminal beherrschen.",
      download: "Jetzt herunterladen",
      version: "Version 2.1.0",
      requires: "Erfordert macOS 12+"
    },
    socialProof: {
      count: "10,000+",
      label: "Downloads und steigend"
    },
    faq: {
      title: "Häufig gestellte Fragen",
      items: [
        {
          q: "Ist es sicher für meine bestehende .zshrc?",
          a: "Absolut. Zshrc Manager verwendet einen zerstörungsfreien Ansatz, indem er eine dedizierte Umgebung erstellt."
        }
      ]
    },
    tech: {
      title: "Gebaut für Ihren Workflow",
      subtitle: "Integriert sich nahtlos in Ihre täglichen Tools"
    }
  },
  fi: {
    common: {
      backToSite: "Takaisin sivustolle",
      backToHome: "Takaisin kotiin",
      advanced: "Lisäasetukset",
    },
    nav: {
      features: "Ominaisuudet",
      docs: "Dokumentaatio",
      buy: "Osta lisenssi"
    },
    hero: {
      badge: "VERSIO 1.2.0 ON NYT JULKINEN",
      title: "Hallitse Zsh-kuortasi",
      subtitle: "Lopullinen macOS-kumppani päätteellesi. Automatisoi Oh My Zsh, hallitse ympäristöpolkuja ja synkronoi asetukset iCloudin kautta – kaikki natiivissa graafisessa käyttöliittymässä.",
      getStarted: "Lataa ilmaiseksi",
      learnMore: "Katso ominaisuudet"
    },
    features: {
      title: "Työkaluja kehittäjille",
      subtitle: "Rakensimme ominaisuudet, joita olet aina halunnut päätteen asetusten hallintaan.",
      cards: [
        {
          title: "Päätteen mestari",
          desc: "Asenna Oh My Zsh ja korkean suorituskyvyn teemat, kuten Powerlevel10k, välittömästi. Ei skriptejä, ei päänvaivaa."
        },
        {
          title: "iCloud-ydin",
          desc: "Aliakset, ympäristöpolut ja liitännäiset synkronoidaan turvallisesti kaikille Maceillesi iCloud Driven kautta."
        },
        {
          title: "Asetustohtori",
          desc: "Automatisoitu diagnostiikka rikkinäisten polkujen tai syntaksivirheiden löytämiseksi ja korjaamiseksi Zsh-asetustiedostoissasi."
        }
      ]
    },
    pricing_page: {
      title: "Yksinkertainen ja läpinäkyvä hinnoittelu",
      subtitle: "Kertamaksu. Elinikäinen pääsy. Ei toistuvia tilauksia.",
      lifetime_license: "Elinikäinen lisenssi",
      lifetime_desc: "Kaikki mitä tarvitset päätteen hallintaan.",
      forever: "ikuisesti",
      buy_now: "Aloita nyt",
      guarantee: "Sisältää 30 päivän rahat takaisin -takuun.",
      trusted_by: "Yli 10 000 kehittäjän luottama maailmanlaajuisesti",
      safe_secure: "Turvallinen & Luotettava",
      safe_desc: "Tietosi eivät koskaan lähde laitteeltasi. iCloud-synkronointi on salattu.",
      money_back: "30 päivän palautusoikeus",
      money_desc: "Jos et ole tyytyväinen, palautamme maksun 30 päivän kuluessa.",
      testimonial_text: "Zshrc Manager on täysin muuttanut tavan, jolla hallitsen pääteympäristöäni. Kertamaksu oli paras investointi kehitysympäristööni.",
      testimonial_author: "Alex Rivera",
      testimonial_role: "Senior DevOps -insinööri",
      features: [
        "Natiivi macOS-sovellus",
        "Visuaalinen Zshrc-editori",
        "Turvallinen iCloud-synkronointi",
        "Elinikäiset päivitykset",
        "Premium-tuki"
      ]
    },
    trust: {
      title: "Kehittäjien luottama",
      nonDestructive: {
        title: "Ei-tuhoava",
        desc: "Turvallinen asetusten hallinta, joka ei koskaan riko ympäristöäsi."
      },
      icloudSecurity: {
        title: "iCloud-turvallisuus",
        desc: "Päästä päähän salattu pilvisynkronointi mielenrauhallesi."
      },
      badges: {
        native: "macOS-natiivi",
        privacy: "Yksityisyys ensin",
        openSource: "Avoin lähdekoodi"
      }
    },
    docs_subpages: {
      install_title: "Asennus",
      install_desc: "Zshrc Manager on saatavilla macOS DMG -pakettina.",
      install_req: "Järjestelmävaatimukset",
      install_step1: "Vaihe 1: Lataa",
      install_step1_desc: "Lataa uusin versio.",
      install_step2: "Vedä Sovelluksiin",
      install_step2_desc: "Vedä kuvake Sovellukset-kansioon.",
      install_step3: "Vaihe 3: Alkuasetukset",
      install_step3_desc: "Zshrc Manager tarkistaa ~/.zshrc-tiedostosi.",
      install_note: "Huom: Täysi levynkäyttöoikeus saatetaan tarvita.",
      tm_title: "Päätemestari",
      tm_desc: "Muuta päätteesi heti työasemaksi.",
      tm_overview: "Kojelaudan yleiskatsaus",
      tm_deploy: "Ota käyttöön Oh My Zsh",
      tm_deploy_desc: "Asennuskomentojen kopiointia ei enää tarvita.",
      cd_title: "Asetuslääkäri",
      cd_desc: "Korjaa syntaksivirheet automaattisesti.",
      sync_title: "iCloud-synkronointi (Pro)",
      sync_desc: "Pidä ympäristösi synkronoituna kaikissa Maceissa.",
      snap_title: "Tilannevedokset",
      snap_desc: "Luo varmuuskopioita yhdellä napsautuksella.",
      python_title: "Python-hallinta",
      python_desc: "Hallitse Pyenv, Anaconda ja Poetry saumattomasti.",
      manual_title: "Manuaaliset asetukset",
      manual_desc: "Kuinka muokata raaka-asetuslohkoja turvallisesti.",
      install_brew: "Asenna Homebrewn kautta",
      install_brew_desc: "Nopein tapa tehokäyttäjille asentaa Zshrc Manager komentoriviltä.",
    },
    docs: {
      intro_title: "Esittely",
      intro_desc: "Zshrc Manager on täydellinen macOS-työpöytäsovellus, joka on suunniteltu yksinkertaistamaan komentoriviympäristön hallintaa. Olitpa kokenut kehittäjä tai vasta-alkaja, työkalumme tarjoaa ammattimaisen graafisen käyttöliittymän Zshin hallintaan.",
      gui_title: "Käyttöliittymä edellä",
      gui_desc: "Ei enää piilotettujen asetustiedostojen muokkaamista Vimissä. Hallitse kaikkea kauniin natiivin macOS-käyttöliittymän kautta.",
      safe_title: "Turvallinen ja luotettava",
      safe_desc: "Jokainen muutos tarkistetaan ja varmuuskopioidaan. Yhden napsautuksen palautus, jos jotain menee pieleen.",
      preview_title: "Visuaalinen esikatselu"
    },
    footer: {
      tagline: "Suunniteltu macOS-tehokäyttäjille",
      product: "Produkt",
      support: "Support",
      legal: "Rechtliches",
      docs: "Dokumentation",
      contact: "Kontaktiere uns",
      changelog: "Änderungsprotokoll",
      refund: "Rückerstattungsrichtlinie",
      copyright: "© 2024 Zshrc Manager. Rakennettu rakkaudella macOS:lle.",
      links: ["Tietosuojakäytäntö", "Käyttöehdot", "GitHub"]
    },
    cta: {
      title: "Oletko valmis muuttamaan Zsh-kokemuksesi?",
      subtitle: "Liity yli 10 000 kehittäjän joukkoon, jotka hallitsevat päätettään.",
      download: "Lataa nyt",
      version: "Versio 2.1.0",
      requires: "Vaatii macOS 12+"
    },
    socialProof: {
      count: "10,000+",
      label: "Latausta ja laskenta jatkuu"
    },
    faq: {
      title: "Usein Kysytyt Kysymykset",
      items: [
        {
          q: "Onko se turvallista nykyiselle .zshrc:lleni?",
          a: "Ehdottomasti. Zshrc Manager käyttää ei-tuhoavaa lähestymistapaa."
        }
      ]
    },
    tech: {
      title: "Rakennettu työnkulkuusi",
      subtitle: "Integroidaan saumattomasti työkaluihin, joita jo käytät"
    }
  },
  ru: {
    common: {
      backToSite: "Вернуться на сайт",
      backToHome: "На главную",
      advanced: "Дополнительно",
    },
    nav: {
      features: "Функции",
      pricing: "Цена",
      security: "Безопасность",
      faq: "FAQ",
      changelog: "История",
      support: "Поддержка",
      download: "Скачать"
    },
    hero: {
      badge: "Создано для macOS",
      title: "Лучший помощник macOS для Zsh",
      subtitle: "Легко управляйте, синхронизируйте и организуйте свои конфиги Zsh",
      getStarted: "Начать",
      learnMore: "Подробнее"
    },
    features: {
      title: "Мощные функции",
      cards: [
        {
          title: "Управление конфигами",
          desc: "Создавайте, редактируйте и организуйте несколько конфигов Zsh с легкостью."
        },
        {
          title: "Переключение профилей",
          desc: "Мгновенно переключайте профили под ваш рабочий процесс."
        },
        {
          title: "Синхронизация iCloud",
          desc: "Бесшовная синхронизация ваших настроек между всеми устройствами."
        },
        {
          title: "Безопасное редактирование",
          desc: "Безопасная правка с бэкапами и встроенной историей версий."
        }
      ]
    },
    pricing_page: {
      title: "Простая и прозрачная цена",
      subtitle: "Разовый платеж. Пожизненный доступ. Без подписок.",
      lifetime_license: "Пожизненная лицензия",
      lifetime_desc: "Все, что нужно для освоения терминала.",
      forever: "навсегда",
      buy_now: "Начать прямо сейчас",
      guarantee: "Включает 30-дневную гарантию возврата денег.",
      trusted_by: "Доверяют более 10 000 разработчиков по всему миру",
      safe_secure: "Надежно и безопасно",
      safe_desc: "Ваши данные никогда не покидают устройство. iCloud синхронизация зашифрована.",
      money_back: "30 дней на возврат",
      money_desc: "Если вы не будете довольны, мы вернем деньги в течение 30 дней.",
      testimonial_text: "Zshrc Manager полностью изменил мой подход к управлению терминалом. Разовая покупка стала лучшим вложением в мою среду разработки.",
      testimonial_author: "Alex Rivera",
      testimonial_role: "Старший DevOps-инженер",
      features: [
        "Нативное приложение для macOS",
        "Визуальный редактор Zshrc",
        "Безопасная синхронизация iCloud",
        "Пожизненные обновления",
        "Премиум-поддержка"
      ]
    },
    trust: {
      title: "Выбор разработчиков",
      nonDestructive: {
        title: "Безопасно",
        desc: "Управление конфигами, которое никогда не сломает вашу систему."
      },
      icloudSecurity: {
        title: "Безопасность iCloud",
        desc: "Зашифрованная облачная синхронизация для вашего спокойствия."
      },
      badges: {
        native: "Нативно для Mac",
        privacy: "Приватность",
        openSource: "Open Source"
      }
    },
    docs_subpages: {
      install_title: "Установка",
      install_desc: "Zshrc Manager распространяется в виде DMG.",
      install_req: "Системные требования",
      install_step1: "Шаг 1: Скачать",
      install_step1_desc: "Загрузите последнюю версию.",
      install_step2: "Перетащите в Приложения",
      install_step2_desc: "Перетащите значок в папку Приложения.",
      install_step3: "Шаг 3: Начальная настройка",
      install_step3_desc: "Zshrc Manager просканирует ваш файл ~/.zshrc.",
      install_note: "Примечание: вам может потребоваться предоставить полный доступ к диску.",
      tm_title: "Мастер терминала",
      tm_desc: "Мгновенно превратите свой терминал в рабочую станцию.",
      tm_overview: "Обзор панели инструментов",
      tm_deploy: "Развернуть Oh My Zsh",
      tm_deploy_desc: "Больше не нужно копировать и вставлять установочные скрипты.",
      cd_title: "Доктор конфигурации",
      cd_desc: "Автоматически исправляйте синтаксические ошибки.",
      sync_title: "Синхронизация iCloud (Pro)",
      sync_desc: "Синхронизируйте среду на всех Mac.",
      snap_title: "Снимки",
      snap_desc: "Создавайте резервные копии одним щелчком мыши.",
      python_title: "Менеджер Python",
      python_desc: "Управляйте Pyenv, Anaconda и Poetry без проблем.",
      manual_title: "Ручные настройки",
      manual_desc: "Как безопасно редактировать блоки конфигурации.",
      install_brew: "Установка через Homebrew",
      install_brew_desc: "Самый быстрый способ для продвинутых пользователей установить Zshrc Manager через командную строку.",
    },
    docs: {
      intro_title: "Введение",
      intro_desc: "Zshrc Manager — это идеальное настольное приложение для macOS, предназначенное для упрощения управления средой вашей оболочки. Независимо от того, являетесь ли вы опытным разработчиком или только начинаете, наш инструмент предоставляет профессиональный графический интерфейс для освоения Zsh.",
      gui_title: "Сначала графический интерфейс",
      gui_desc: "Больше не нужно редактировать скрытые конфигурационные файлы в Vim. Управляйте всем через красивый нативный интерфейс macOS.",
      safe_title: "Безопасно и надежно",
      safe_desc: "Каждое изменение проверяется и копируется. Восстановление в один клик, если что-то пойдет не так.",
      preview_title: "Визуальный предварительный просмотр"
    },
    footer: {
      tagline: "Создано для опытных пользователей macOS",
      product: "Продукт",
      support: "Поддержка",
      legal: "Юридическая информация",
      docs: "Документация",
      contact: "Связаться с нами",
      changelog: "Журнал изменений",
      refund: "Политика возврата",
      copyright: "© 2024 Zshrc Manager. Все права защищены.",
      links: ["Приватность", "Условия", "GitHub"]
    },
    cta: {
      title: "Готовы изменить свой опыт работы с Zsh?",
      subtitle: "Присоединяйтесь к 10 000+ разработчикам, которые уже освоили свой терминал.",
      download: "Скачать сейчас",
      version: "Версия 2.1.0",
      requires: "Требуется macOS 12+"
    },
    socialProof: {
      count: "10,000+",
      label: "загрузок и это только начало"
    },
    faq: {
      title: "Часто задаваемые вопросы",
      items: [
        {
          q: "Безопасно ли это для моего .zshrc?",
          a: "Абсолютно. Zshrc Manager использует неразрушающий подход."
        }
      ]
    },
    tech: {
      title: "Создано для вашего рабочего процесса",
      subtitle: "Плавно интегрируется с инструментами, которыми вы уже пользуетесь"
    }
  }
};
