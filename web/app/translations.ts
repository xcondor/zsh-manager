export type Language = 'en' | 'zh' | 'zh_Hant' | 'ko' | 'ja' | 'fr' | 'de' | 'fi' | 'ru';

export const translations: Record<Language, any> = {
  en: {
    nav: {
      features: "Features",
      docs: "Docs",
      buy: "Buy License"
    },
    hero: {
      version: "VERSION 1.2.0 IS NOW PUBLIC",
      title1: "Master Your",
      title2: "Zsh Shell",
      subtitle: "The ultimate macOS companion for your terminal. Automate Oh My Zsh, manage environment paths, and sync configs via iCloud—all in a native GUI.",
      download: "Download Free",
      viewFeatures: "View Features"
    },
    features: {
      title: "Tools for Developers",
      subtitle: "We built the features you always wanted in your terminal configuration workflow.",
      cards: [
        {
          title: "Terminal Master",
          desc: "Install Oh My Zsh and high-performance themes like Powerlevel10k instantly. No scripts, no headaches."
        },
        {
          title: "iCloud Core",
          desc: "Your aliases, environment paths, and plugins synced securely across all your Macs via iCloud Drive."
        },
        {
          title: "Config Doctor",
          desc: "Automated diagnostics to find and fix broken paths or syntax errors in your Zsh configuration files."
        }
      ]
    },
    pricing: {
      offer: "Limited Time Offer",
      title: "Get Lifetime Access to",
      subtitle: "Pay once, use forever. No subscriptions. Unlock iCloud Sync, Advanced Diagnostics, and Priority Updates today.",
      buy: "Claim Your License Now",
      features: ["Secure Checkout", "14-Day Refund", "Instant Keys"]
    },
    footer: {
      tagline: "Hand-crafted for developers who value their terminal environment.",
      product: "Product",
      connect: "Connect",
      copyright: "© 2024 Zshrc Manager. Built with love for macOS."
    }
  },
  zh: {
    nav: {
      features: "功能特性",
      docs: "文档",
      buy: "购买授权"
    },
    hero: {
      version: "1.2.0 版本现已发布",
      title1: "掌控您的",
      title2: "Zsh 终端",
      subtitle: "您的终端终极 macOS 伴侣。自动化 Oh My Zsh，管理环境变量，并通过 iCloud 同步配置——全部在原生 GUI 中完成。",
      download: "免费下载",
      viewFeatures: "查看功能"
    },
    features: {
      title: "开发者专属工具",
      subtitle: "我们构建了您在终端配置工作流程中一直梦寐以求的功能。",
      cards: [
        {
          title: "终端大师",
          desc: "立即安装 Oh My Zsh 和 Powerlevel10k 等高性能主题。无需脚本，拒绝头疼。"
        },
        {
          title: "iCloud 核心同步",
          desc: "您的别名、环境路径和插件可通过 iCloud Drive 在所有 Mac 之间安全同步。"
        },
        {
          title: "配置医生",
          desc: "自动诊断并修复 Zsh 配置文件中的损坏路径或语法错误。"
        }
      ]
    },
    pricing: {
      offer: "限时优惠",
      title: "获取终身访问权限",
      subtitle: "一次性付费，永久使用。无订阅。立即解锁 iCloud 同步、高级诊断和优先更新。",
      buy: "立即获取授权",
      features: ["安全结账", "14 天退款保证", "即时发码"]
    },
    footer: {
      tagline: "为珍视终端环境的开发者精心打造。",
      product: "产品",
      connect: "联系我们",
      copyright: "© 2024 Zshrc Manager. 为 macOS 倾情打造。"
    }
  },
  zh_Hant: {
    nav: {
      features: "功能特性",
      docs: "文檔",
      buy: "購買授權"
    },
    hero: {
      version: "1.2.0 版本現已發佈",
      title1: "掌控您的",
      title2: "Zsh 終端",
      subtitle: "您的終端終極 macOS 伴侶。自動化 Oh My Zsh，管理環境變量，並通過 iCloud 同步配置——全部在原生 GUI 中完成。",
      download: "免費下載",
      viewFeatures: "查看功能"
    },
    features: {
      title: "開發者專屬工具",
      subtitle: "我們構建了您在終端配置工作流程中一直夢寐以求的功能。",
      cards: [
        {
          title: "終端大師",
          desc: "立即安裝 Oh My Zsh 和 Powerlevel10k 等高性能主題。無需腳本，拒絕頭疼。"
        },
        {
          title: "iCloud 核心同步",
          desc: "您的別名、環境路徑和插件可通過 iCloud Drive 在所有 Mac 之間安全同步。"
        },
        {
          title: "配置醫生",
          desc: "自動診斷並修復 Zsh 配置文件中的損壞路徑或語法錯誤。"
        }
      ]
    },
    pricing: {
      offer: "限時優惠",
      title: "獲取終身訪問權限",
      subtitle: "一次性付費，永久使用。無訂閱。立即解鎖 iCloud 同步、高級診斷和優先更新。",
      buy: "立即獲取授權",
      features: ["安全結賬", "14 天退款保證", "即時發碼"]
    },
    footer: {
      tagline: "為珍視終端環境的開發者精心打造。",
      product: "產品",
      connect: "聯繫我們",
      copyright: "© 2024 Zshrc Manager. 為 macOS 傾情打造。"
    }
  },
  ko: {
    nav: {
      features: "기능",
      docs: "문서",
      buy: "라이선스 구매"
    },
    hero: {
      version: "버전 1.2.0 정식 출시",
      title1: "당신의",
      title2: "Zsh 셸 마스터",
      subtitle: "터미널을 위한 최고의 macOS 동반자. Oh My Zsh 자동화, 환경 경로 관리, iCloud를 통한 설정 동기화—모두 네이티브 GUI에서 가능합니다.",
      download: "무료 다운로드",
      viewFeatures: "기능 보기"
    },
    features: {
      title: "개발자를 위한 도구",
      subtitle: "터미널 설정 워크플로우에서 항상 원했던 기능을 구현했습니다.",
      cards: [
        {
          title: "터미널 마스터",
          desc: "Oh My Zsh와 Powerlevel10k 같은 고성능 테마를 즉시 설치하세요. 스크립트도, 고민도 필요 없습니다."
        },
        {
          title: "iCloud 코어",
          desc: "별칭, 환경 경로 및 플러그인이 iCloud Drive를 통해 모든 Mac에서 안전하게 동기화됩니다."
        },
        {
          title: "설정 닥터",
          desc: "Zsh 설정 파일의 손상된 경로 또는 구문 오류를 찾아 수정하는 자동 진단 기능입니다."
        }
      ]
    },
    pricing: {
      offer: "기간 한정 제안",
      title: "평생 이용권 획득",
      subtitle: "한 번 결제로 평생 이용하세요. 구독이 없습니다. 오늘 iCloud 동기화, 고급 진단 및 우선 업데이트를 잠금 해제하세요.",
      buy: "지금 라이선스 받기",
      features: ["안전한 결제", "14일 환불 보장", "즉시 키 발급"]
    },
    footer: {
      tagline: "터미널 환경을 소중히 여기는 개발자를 위해 정성껏 만들었습니다.",
      product: "제품",
      connect: "연결",
      copyright: "© 2024 Zshrc Manager. macOS를 위해 사랑으로 제작되었습니다."
    }
  },
  ja: {
    nav: {
      features: "機能",
      docs: "ドキュメント",
      buy: "ライセンス購入"
    },
    hero: {
      version: "バージョン 1.2.0 公開開始",
      title1: "あなたの",
      title2: "Zshシェルをマスター",
      subtitle: "ターミナル用の究極のmacOSコンパニオン。Oh My Zshの自動化、環境パスの管理、iCloud経由の設定同期—すべてネイティブGUIで完結します。",
      download: "無料でダウンロード",
      viewFeatures: "機能を見る"
    },
    features: {
      title: "開発者のためのツール",
      subtitle: "ターミナル構成ワークフローで常に求められていた機能を構築しました。",
      cards: [
        {
          title: "ターミナルマスター",
          desc: "Oh My ZshやPowerlevel10kのような高性能テーマを即座にインストール。スクリプト不要、悩み無用。"
        },
        {
          title: "iCloudコア",
          desc: "エイリアス、環境パス、プラグインがiCloud Drive経由ですべてのMac間で安全に同期されます。"
        },
        {
          title: "構成ドクター",
          desc: "Zsh構成ファイルの壊れたパスや構文エラーを見つけて修正する自動診断。"
        }
      ]
    },
    pricing: {
      offer: "期間限定オファー",
      title: "生涯アクセス権を取得",
      subtitle: "一度の支払いで、一生使えます。サブスクリプションなし。今すぐiCloud同期、高度な診断、優先アップデートをアンロックしましょう。",
      buy: "今すぐライセンスを取得",
      features: ["安全なチェックアウト", "14日間返金保証", "即時キー発行"]
    },
    footer: {
      tagline: "ターミナル環境を大切にする開発者のために、心を込めて作られました。",
      product: "製品",
      connect: "連携",
      copyright: "© 2024 Zshrc Manager. macOSへの愛を込めて構築されました。"
    }
  },
  fr: {
    nav: {
      features: "Fonctionnalités",
      docs: "Docs",
      buy: "Acheter une licence"
    },
    hero: {
      version: "LA VERSION 1.2.0 EST MAINTENANT PUBLIQUE",
      title1: "Maîtrisez Votre",
      title2: "Shell Zsh",
      subtitle: "Le compagnon macOS ultime pour votre terminal. Automatisez Oh My Zsh, gérez les chemins d'environnement et synchronisez les configurations via iCloud—le tout dans une interface graphique native.",
      download: "Télécharger gratuitement",
      viewFeatures: "Voir les fonctionnalités"
    },
    features: {
      title: "Outils pour Développeurs",
      subtitle: "Nous avons conçu les fonctionnalités que vous avez toujours voulues dans votre flux de travail de configuration de terminal.",
      cards: [
        {
          title: "Maître du Terminal",
          desc: "Installez Oh My Zsh et des thèmes haute performance comme Powerlevel10k instantanément. Pas de scripts, pas de maux de tête."
        },
        {
          title: "Cœur iCloud",
          desc: "Vos alias, chemins d'environnement et plugins synchronisés en toute sécurité sur tous vos Mac via iCloud Drive."
        },
        {
          title: "Docteur de Config",
          desc: "Diagnostics automatisés pour trouver et corriger les chemins rompus ou les erreurs de syntaxe dans vos fichiers de configuration Zsh."
        }
      ]
    },
    pricing: {
      offer: "Offre à Durée Limitée",
      title: "Obtenez un Accès à Vie à",
      subtitle: "Payez une fois, utilisez pour toujours. Pas d'abonnements. Débloquez la synchronisation iCloud, les diagnostics avancés et les mises à jour prioritaires dès aujourd'hui.",
      buy: "Réclamez votre licence maintenant",
      features: ["Paiement sécurisé", "Remboursement sous 14 jours", "Clés instantanées"]
    },
    footer: {
      tagline: "Fabriqué à la main pour les développeurs qui apprécient leur environnement de terminal.",
      product: "Produit",
      connect: "Contact",
      copyright: "© 2024 Zshrc Manager. Construit avec amour pour macOS."
    }
  },
  de: {
    nav: {
      features: "Funktionen",
      docs: "Docs",
      buy: "Lizenz kaufen"
    },
    hero: {
      version: "VERSION 1.2.0 IST JETZT ÖFFENTLICH",
      title1: "Beherrschen Sie Ihre",
      title2: "Zsh Shell",
      subtitle: "Der ultimative macOS-Begleiter für Ihr Terminal. Automatisieren Sie Oh My Zsh, verwalten Sie Umgebungspfade und synchronisieren Sie Konfigurationen über iCloud – alles in einer nativen GUI.",
      download: "Kostenlos herunterladen",
      viewFeatures: "Funktionen ansehen"
    },
    features: {
      title: "Tools für Entwickler",
      subtitle: "Wir haben die Funktionen entwickelt, die Sie sich schon immer für Ihren Terminal-Konfigurations-Workflow gewünscht haben.",
      cards: [
        {
          title: "Terminal-Meister",
          desc: "Installieren Sie Oh My Zsh und Hochleistungs-Themes wie Powerlevel10k sofort. Keine Skripte, kein Kopfzerbrechen."
        },
        {
          title: "iCloud-Kern",
          desc: "Ihre Aliase, Umgebungspfade und Plugins werden über iCloud Drive sicher auf allen Ihren Macs synchronisiert."
        },
        {
          title: "Konfig-Doktor",
          desc: "Automatisierte Diagnose zum Finden und Beheben fehlerhafter Pfade oder Syntaxfehler in Ihren Zsh-Konfigurationsdateien."
        }
      ]
    },
    pricing: {
      offer: "Befristetes Angebot",
      title: "Holen Sie sich lebenslangen Zugang zu",
      subtitle: "Einmal zahlen, ewig nutzen. Keine Abonnements. Schalten Sie noch heute iCloud-Sync, erweiterte Diagnose und vorrangige Updates frei.",
      buy: "Holen Sie sich jetzt Ihre Lizenz",
      features: ["Sicheres Bezahlen", "14 Tage Rückgaberecht", "Sofortige Keys"]
    },
    footer: {
      tagline: "Handgefertigt für Entwickler, die ihre Terminalumgebung schätzen.",
      product: "Produkt",
      connect: "Verbinden",
      copyright: "© 2024 Zshrc Manager. Mit Liebe für macOS entwickelt."
    }
  },
  fi: {
    nav: {
      features: "Ominaisuudet",
      docs: "Dokumentaatio",
      buy: "Osta lisenssi"
    },
    hero: {
      version: "VERSIO 1.2.0 ON NYT JULKINEN",
      title1: "Hallitse",
      title2: "Zsh-kuortasi",
      subtitle: "Lopullinen macOS-kumppani päätteellesi. Automatisoi Oh My Zsh, hallitse ympäristöpolkuja ja synkronoi asetukset iCloudin kautta – kaikki natiivissa graafisessa käyttöliittymässä.",
      download: "Lataa ilmaiseksi",
      viewFeatures: "Katso ominaisuudet"
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
    pricing: {
      offer: "Rajoitetun ajan tarjous",
      title: "Hanki elinikäinen pääsy",
      subtitle: "Maksa kerran, käytä ikuisesti. Ei tilauksia. Avaa iCloud-synkronointi, edistynyt diagnostiikka ja ensisijaiset päivitykset tänään.",
      buy: "Lunasta lisenssisi nyt",
      features: ["Turvallinen kassalle", "14 päivän palautusoikeus", "Välittömät avaimet"]
    },
    footer: {
      tagline: "Käsityönä kehittäjille, jotka arvostavat pääteympäristöään.",
      product: "Tuote",
      connect: "Yhteydenotto",
      copyright: "© 2024 Zshrc Manager. Rakennettu rakkaudella macOS:lle."
    }
  },
  ru: {
    nav: {
      features: "Возможности",
      docs: "Документация",
      buy: "Купить лицензию"
    },
    hero: {
      version: "ВЕРСИЯ 1.2.0 ТЕПЕРЬ ДОСТУПНА",
      title1: "Освойте Свою",
      title2: "Оболочку Zsh",
      subtitle: "Лучший помощник macOS для вашего терминала. Автоматизируйте Oh My Zsh, управляйте путями среды и синхронизируйте конфигурации через iCloud — и все это в нативном графическом интерфейсе.",
      download: "Скачать бесплатно",
      viewFeatures: "Посмотреть функции"
    },
    features: {
      title: "Инструменты для разработчиков",
      subtitle: "Мы создали функции, которые вы всегда хотели видеть в рабочем процессе настройки терминала.",
      cards: [
        {
          title: "Мастер Терминала",
          desc: "Мгновенно устанавливайте Oh My Zsh и высокопроизводительные темы, такие как Powerlevel10k. Никаких скриптов, никаких проблем."
        },
        {
          title: "Ядро iCloud",
          desc: "Ваши псевдонимы, пути среды и плагины надежно синхронизируются на всех ваших Mac через iCloud Drive."
        },
        {
          title: "Конфиг-Доктор",
          desc: "Автоматизированная диагностика для поиска и исправления битых путей или синтаксических ошибок в файлах конфигурации Zsh."
        }
      ]
    },
    pricing: {
      offer: "Ограниченное по времени предложение",
      title: "Получите пожизненный доступ к",
      subtitle: "Платите один раз, пользуйтесь всегда. Никаких подписок. Разблокируйте синхронизацию iCloud, расширенную диагностику и приоритетные обновления уже сегодня.",
      buy: "Получить лицензию сейчас",
      features: ["Безопасная оплата", "14-дневный возврат", "Мгновенные ключи"]
    },
    footer: {
      tagline: "Создано вручную для разработчиков, которые ценят свою терминальную среду.",
      product: "Продукт",
      connect: "Связь",
      copyright: "© 2024 Zshrc Manager. Сделано с любовью для macOS."
    }
  }
};
