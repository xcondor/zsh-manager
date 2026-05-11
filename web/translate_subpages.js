const fs = require('fs');

const subpageTranslations = {
  en: {
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
    manual_desc: "For advanced users: How to safely edit raw configuration blocks within Zshrc Manager."
  },
  zh: {
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
    tm_deploy_desc: "Oh My Zsh 是 modern 终端的基础。有了 Zshrc Manager，您无需复制粘贴安装脚本。只需在核心组件部分点击 Oh My Zsh 旁边的“安装”即可。",
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
    manual_desc: "针对高级用户：如何在 Zshrc Manager 中安全地编辑原始配置块。"
  },
  zh_Hant: {
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
    manual_desc: "針對高級用戶：如何在 Zshrc Manager 中安全地編輯原始設定區塊。"
  },
  ja: {
    install_title: "インストール", install_desc: "Zshrc Managerは標準のmacOS DMGパッケージとして配布されています。", install_req: "システム要件", install_step1: "ステップ1: ダウンロード", install_step1_desc: "公式サイトからZshrc Managerの最新バージョンをダウンロードしてください。", install_step2: "アプリケーションにドラッグ", install_step2_desc: "ダウンロードしたDMGを開き、Zshrc Managerアイコンをアプリケーションフォルダにドラッグします。", install_step3: "ステップ3: 初期設定", install_step3_desc: "初回起動時、Zshrc Managerは~/.zshrcファイルをスキャンします。", install_note: "注：フルディスクアクセスを許可する必要があります。",
    tm_title: "ターミナルマスター", tm_desc: "手動設定なしでターミナルをプロのワークステーションに変換します。", tm_overview: "ダッシュボードの概要", tm_deploy: "Oh My Zshを展開", tm_deploy_desc: "Zshrc Managerを使えばインストールスクリプトをコピペする必要はありません。", cd_title: "構成ドクター", cd_desc: "構文エラーやパスの競合を自動的に修正します。", sync_title: "iCloud 同期 (Pro)", sync_desc: "すべてのMacでターミナル環境を完全に同期します。", snap_title: "スナップショット", snap_desc: "Zsh環境全体のバックアップをワンクリックで作成します。", python_title: "Pythonマネージャー", python_desc: "Pyenv、Anaconda、Poetryのパスをシームレスに管理します。", manual_title: "手動設定", manual_desc: "Zshrc Managerで生の構成ブロックを安全に編集する方法。"
  },
  ko: {
    install_title: "설치", install_desc: "Zshrc Manager는 표준 macOS DMG 패키지로 배포됩니다.", install_req: "시스템 요구 사항", install_step1: "1단계: 다운로드", install_step1_desc: "공식 웹사이트에서 Zshrc Manager의 최신 버전을 다운로드하십시오.", install_step2: "응용 프로그램으로 드래그", install_step2_desc: "다운로드한 DMG를 열고 Zshrc Manager 아이콘을 응용 프로그램 폴더로 드래그합니다.", install_step3: "3단계: 초기 설정", install_step3_desc: "첫 실행 시 Zshrc Manager는 ~/.zshrc 파일을 스캔합니다.", install_note: "참고: 전체 디스크 접근 권한을 부여해야 할 수 있습니다.",
    tm_title: "터미널 마스터", tm_desc: "수동 구성 없이 터미널을 전문 워크스테이션으로 즉시 변환합니다.", tm_overview: "대시보드 개요", tm_deploy: "Oh My Zsh 배포", tm_deploy_desc: "Zshrc Manager를 사용하면 설치 스크립트를 복사하여 붙여넣을 필요가 없습니다.", cd_title: "구성 닥터", cd_desc: "구문 오류 및 경로 충돌을 자동으로 수정합니다.", sync_title: "iCloud 동기화 (Pro)", sync_desc: "모든 Mac에서 터미널 환경을 완벽하게 동기화합니다.", snap_title: "스냅샷", snap_desc: "클릭 한 번으로 전체 Zsh 환경의 백업을 생성합니다.", python_title: "Python 관리자", python_desc: "Pyenv, Anaconda, Poetry 경로를 원활하게 관리합니다.", manual_title: "수동 구성", manual_desc: "Zshrc Manager에서 원시 구성 블록을 안전하게 편집하는 방법."
  },
  fr: {
    install_title: "Installation", install_desc: "Zshrc Manager est distribué sous forme de package DMG macOS standard.", install_req: "Configuration requise", install_step1: "Étape 1: Télécharger", install_step1_desc: "Téléchargez la dernière version depuis le site officiel.", install_step2: "Faites glisser vers Applications", install_step2_desc: "Ouvrez le DMG et faites glisser l'icône dans le dossier Applications.", install_step3: "Étape 3: Configuration initiale", install_step3_desc: "Au premier lancement, Zshrc Manager analysera votre fichier ~/.zshrc.", install_note: "Remarque : un accès complet au disque peut être nécessaire.",
    tm_title: "Maître du terminal", tm_desc: "Transformez instantanément votre terminal en station de travail.", tm_overview: "Aperçu du tableau de bord", tm_deploy: "Déployer Oh My Zsh", tm_deploy_desc: "Plus besoin de copier-coller des scripts d'installation.", cd_title: "Docteur de configuration", cd_desc: "Corrigez automatiquement les erreurs de syntaxe et les conflits de chemin.", sync_title: "Synchronisation iCloud (Pro)", sync_desc: "Gardez votre environnement synchronisé sur tous vos Mac.", snap_title: "Instantanés", snap_desc: "Créez des sauvegardes de votre environnement Zsh en un clic.", python_title: "Gestionnaire Python", python_desc: "Gérez les chemins Pyenv, Anaconda et Poetry sans problème.", manual_title: "Configurations manuelles", manual_desc: "Comment modifier en toute sécurité les blocs de configuration bruts."
  },
  de: {
    install_title: "Installation", install_desc: "Zshrc Manager wird als macOS-DMG verteilt.", install_req: "Systemanforderungen", install_step1: "Schritt 1: Herunterladen", install_step1_desc: "Laden Sie die neueste Version herunter.", install_step2: "In Anwendungen ziehen", install_step2_desc: "Ziehen Sie das Symbol in den Ordner Programme.", install_step3: "Schritt 3: Ersteinrichtung", install_step3_desc: "Zshrc Manager scannt Ihre ~/.zshrc-Datei.", install_note: "Hinweis: Möglicherweise müssen Sie Festplattenvollzugriff gewähren.",
    tm_title: "Terminal-Meister", tm_desc: "Verwandeln Sie Ihr Terminal sofort in eine Workstation.", tm_overview: "Dashboard-Übersicht", tm_deploy: "Oh My Zsh bereitstellen", tm_deploy_desc: "Kein Kopieren und Einfügen von Installationsskripten mehr.", cd_title: "Konfigurationsdoktor", cd_desc: "Syntaxfehler und Pfadkonflikte automatisch beheben.", sync_title: "iCloud-Synchronisierung (Pro)", sync_desc: "Halten Sie Ihre Umgebung auf allen Macs synchron.", snap_title: "Schnappschüsse", snap_desc: "Erstellen Sie mit einem Klick Backups Ihrer Zsh-Umgebung.", python_title: "Python-Manager", python_desc: "Verwalten Sie Pyenv, Anaconda und Poetry nahtlos.", manual_title: "Manuelle Konfigurationen", manual_desc: "So bearbeiten Sie Rohkonfigurationsblöcke sicher."
  },
  ru: {
    install_title: "Установка", install_desc: "Zshrc Manager распространяется в виде DMG.", install_req: "Системные требования", install_step1: "Шаг 1: Скачать", install_step1_desc: "Загрузите последнюю версию.", install_step2: "Перетащите в Приложения", install_step2_desc: "Перетащите значок в папку Приложения.", install_step3: "Шаг 3: Начальная настройка", install_step3_desc: "Zshrc Manager просканирует ваш файл ~/.zshrc.", install_note: "Примечание: вам может потребоваться предоставить полный доступ к диску.",
    tm_title: "Мастер терминала", tm_desc: "Мгновенно превратите свой терминал в рабочую станцию.", tm_overview: "Обзор панели инструментов", tm_deploy: "Развернуть Oh My Zsh", tm_deploy_desc: "Больше не нужно копировать и вставлять установочные скрипты.", cd_title: "Доктор конфигурации", cd_desc: "Автоматически исправляйте синтаксические ошибки.", sync_title: "Синхронизация iCloud (Pro)", sync_desc: "Синхронизируйте среду на всех Mac.", snap_title: "Снимки", snap_desc: "Создавайте резервные копии одним щелчком мыши.", python_title: "Менеджер Python", python_desc: "Управляйте Pyenv, Anaconda и Poetry без проблем.", manual_title: "Ручные настройки", manual_desc: "Как безопасно редактировать блоки конфигурации."
  },
  fi: {
    install_title: "Asennus", install_desc: "Zshrc Manager on saatavilla macOS DMG -pakettina.", install_req: "Järjestelmävaatimukset", install_step1: "Vaihe 1: Lataa", install_step1_desc: "Lataa uusin versio.", install_step2: "Vedä Sovelluksiin", install_step2_desc: "Vedä kuvake Sovellukset-kansioon.", install_step3: "Vaihe 3: Alkuasetukset", install_step3_desc: "Zshrc Manager tarkistaa ~/.zshrc-tiedostosi.", install_note: "Huom: Täysi levynkäyttöoikeus saatetaan tarvita.",
    tm_title: "Päätemestari", tm_desc: "Muuta päätteesi heti työasemaksi.", tm_overview: "Kojelaudan yleiskatsaus", tm_deploy: "Ota käyttöön Oh My Zsh", tm_deploy_desc: "Asennuskomentojen kopiointia ei enää tarvita.", cd_title: "Asetuslääkäri", cd_desc: "Korjaa syntaksivirheet automaattisesti.", sync_title: "iCloud-synkronointi (Pro)", sync_desc: "Pidä ympäristösi synkronoituna kaikissa Maceissa.", snap_title: "Tilannevedokset", snap_desc: "Luo varmuuskopioita yhdellä napsautuksella.", python_title: "Python-hallinta", python_desc: "Hallitse Pyenv, Anaconda ja Poetry saumattomasti.", manual_title: "Manuaaliset asetukset", manual_desc: "Kuinka muokata raaka-asetuslohkoja turvallisesti."
  }
};

let content = fs.readFileSync('app/translations.ts', 'utf8');
let lines = content.split('\n');

// Remove existing docs_subpages if we ran this multiple times
const startIndex = lines.findIndex(l => l.includes('docs_subpages: {'));
if (startIndex !== -1) {
  let openBraces = 0;
  let endIndex = startIndex;
  for (let i = startIndex; i < lines.length; i++) {
    if (lines[i].includes('{')) openBraces++;
    if (lines[i].includes('}')) openBraces--;
    if (openBraces === 0) {
      endIndex = i;
      break;
    }
  }
  lines.splice(startIndex, endIndex - startIndex + 1);
}

// Inject docs_subpages into each language
for (let i = 0; i < lines.length; i++) {
  if (lines[i].includes('docs: {')) {
    let lang = 'en';
    for (let j = i; j >= 0; j--) {
      if (lines[j].match(/^\s+([a-zA-Z_]+):\s+\{/)) {
        lang = lines[j].match(/^\s+([a-zA-Z_]+):\s+\{/)[1];
        if (subpageTranslations[lang]) break;
      }
    }
    
    if (subpageTranslations[lang]) {
      const t = subpageTranslations[lang];
      lines.splice(i, 0, 
        `    docs_subpages: {`,
        Object.entries(t).map(([k, v]) => `      ${k}: "${v.replace(/"/g, '\\"')}",`).join('\n'),
        `    },`
      );
      i += 3; // roughly advance past insertion
    }
  }
}

fs.writeFileSync('app/translations.ts', lines.join('\n'));
console.log("Subpage translations added successfully!");
