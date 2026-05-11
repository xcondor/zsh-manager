const fs = require('fs');

let content = fs.readFileSync('app/translations.ts', 'utf8');

const docsTranslations = {
  en: {
    intro_title: "Introduction",
    intro_desc: "Zshrc Manager is the ultimate macOS desktop application designed to simplify your shell environment management. Whether you're a seasoned developer or just starting out, our tool provides a professional GUI to master Zsh.",
    gui_title: "GUI First",
    gui_desc: "No more editing hidden dotfiles in Vim. Manage everything via a beautiful Native macOS interface.",
    safe_title: "Safe & Reliable",
    safe_desc: "Every change is validated and backed up. One click restoration if anything goes wrong.",
    preview_title: "Visual Preview"
  },
  zh: {
    intro_title: "介绍",
    intro_desc: "Zshrc Manager 是终极 macOS 桌面应用，旨在简化您的终端环境管理。无论您是经验丰富的开发者还是初学者，我们的工具都提供专业的图形界面让您掌控 Zsh。",
    gui_title: "图形界面优先",
    gui_desc: "不再需要在 Vim 中编辑隐藏的配置文件。通过精美的原生 macOS 界面管理一切。",
    safe_title: "安全可靠",
    safe_desc: "每次更改都会经过验证和备份。如果出现任何问题，一键即可恢复。",
    preview_title: "视觉预览"
  },
  zh_Hant: {
    intro_title: "介紹",
    intro_desc: "Zshrc Manager 是終極 macOS 桌面應用，旨在簡化您的終端環境管理。無論您是經驗豐富的開發者還是初學者，我們的工具都提供專業的圖形界面讓您掌控 Zsh。",
    gui_title: "圖形界面優先",
    gui_desc: "不再需要在 Vim 中編輯隱藏的配置文件。透過精美的原生 macOS 界面管理一切。",
    safe_title: "安全可靠",
    safe_desc: "每次更改都會經過驗證和備份。如果出現任何問題，一鍵即可恢復。",
    preview_title: "視覺預覽"
  },
  ja: {
    intro_title: "はじめに",
    intro_desc: "Zshrc Manager は、シェル環境の管理を簡素化するために設計された究極の macOS デスクトップアプリケーションです。経験豊富な開発者でも初心者でも、私たちのツールは Zsh をマスターするためのプロフェッショナルな GUI を提供します。",
    gui_title: "GUI ファースト",
    gui_desc: "Vim で隠し設定ファイルを編集する必要はもうありません。美しいネイティブ macOS インターフェースですべてを管理します。",
    safe_title: "安全で信頼性が高い",
    safe_desc: "すべての変更は検証され、バックアップされます。何か問題が発生した場合はワンクリックで復元できます。",
    preview_title: "ビジュアルプレビュー"
  },
  ko: {
    intro_title: "소개",
    intro_desc: "Zshrc Manager는 셸 환경 관리를 간소화하도록 설계된 궁극의 macOS 데스크톱 애플리케이션입니다. 경험이 풍부한 개발자든 초보자든, 우리의 도구는 Zsh를 마스터하기 위한 전문적인 GUI를 제공합니다.",
    gui_title: "GUI 우선",
    gui_desc: "더 이상 Vim에서 숨겨진 구성 파일을 편집할 필요가 없습니다. 아름다운 네이티브 macOS 인터페이스를 통해 모든 것을 관리하세요.",
    safe_title: "안전하고 신뢰할 수 있음",
    safe_desc: "모든 변경 사항은 검증되고 백업됩니다. 문제가 발생하면 원클릭으로 복원할 수 있습니다.",
    preview_title: "시각적 미리보기"
  },
  fr: {
    intro_title: "Introduction",
    intro_desc: "Zshrc Manager est l'application de bureau macOS ultime conçue pour simplifier la gestion de votre environnement shell. Que vous soyez un développeur expérimenté ou débutant, notre outil offre une interface graphique professionnelle pour maîtriser Zsh.",
    gui_title: "Priorité à l'interface graphique",
    gui_desc: "Plus besoin d'éditer des fichiers de configuration cachés dans Vim. Gérez tout via une belle interface macOS native.",
    safe_title: "Sûr et fiable",
    safe_desc: "Chaque modification est validée et sauvegardée. Restauration en un clic en cas de problème.",
    preview_title: "Aperçu visuel"
  },
  de: {
    intro_title: "Einführung",
    intro_desc: "Zshrc Manager ist die ultimative macOS-Desktop-Anwendung zur Vereinfachung Ihrer Shell-Umgebungsverwaltung. Egal, ob Sie ein erfahrener Entwickler sind oder gerade erst anfangen, unser Tool bietet eine professionelle GUI, um Zsh zu meistern.",
    gui_title: "GUI zuerst",
    gui_desc: "Kein Bearbeiten versteckter Konfigurationsdateien mehr in Vim. Verwalten Sie alles über eine schöne native macOS-Schnittstelle.",
    safe_title: "Sicher & Zuverlässig",
    safe_desc: "Jede Änderung wird validiert und gesichert. Ein-Klick-Wiederherstellung, falls etwas schief geht.",
    preview_title: "Visuelle Vorschau"
  },
  ru: {
    intro_title: "Введение",
    intro_desc: "Zshrc Manager — это идеальное настольное приложение для macOS, предназначенное для упрощения управления средой вашей оболочки. Независимо от того, являетесь ли вы опытным разработчиком или только начинаете, наш инструмент предоставляет профессиональный графический интерфейс для освоения Zsh.",
    gui_title: "Сначала графический интерфейс",
    gui_desc: "Больше не нужно редактировать скрытые конфигурационные файлы в Vim. Управляйте всем через красивый нативный интерфейс macOS.",
    safe_title: "Безопасно и надежно",
    safe_desc: "Каждое изменение проверяется и копируется. Восстановление в один клик, если что-то пойдет не так.",
    preview_title: "Визуальный предварительный просмотр"
  },
  es: {
    intro_title: "Introducción",
    intro_desc: "Zshrc Manager es la aplicación de escritorio definitiva para macOS diseñada para simplificar la gestión de su entorno de shell. Ya sea que sea un desarrollador experimentado o recién comience, nuestra herramienta proporciona una GUI profesional para dominar Zsh.",
    gui_title: "GUI primero",
    gui_desc: "No más ediciones de archivos de configuración ocultos en Vim. Gestione todo a través de una hermosa interfaz nativa de macOS.",
    safe_title: "Seguro y confiable",
    safe_desc: "Cada cambio es validado y respaldado. Restauración con un solo clic si algo sale mal.",
    preview_title: "Vista previa visual"
  },
  fi: {
    intro_title: "Esittely",
    intro_desc: "Zshrc Manager on täydellinen macOS-työpöytäsovellus, joka on suunniteltu yksinkertaistamaan komentoriviympäristön hallintaa. Olitpa kokenut kehittäjä tai vasta-alkaja, työkalumme tarjoaa ammattimaisen graafisen käyttöliittymän Zshin hallintaan.",
    gui_title: "Käyttöliittymä edellä",
    gui_desc: "Ei enää piilotettujen asetustiedostojen muokkaamista Vimissä. Hallitse kaikkea kauniin natiivin macOS-käyttöliittymän kautta.",
    safe_title: "Turvallinen ja luotettava",
    safe_desc: "Jokainen muutos tarkistetaan ja varmuuskopioidaan. Yhden napsautuksen palautus, jos jotain menee pieleen.",
    preview_title: "Visuaalinen esikatselu"
  }
};

let lines = content.split('\n');
for (let i = 0; i < lines.length; i++) {
  if (lines[i].includes('footer: {')) {
    let lang = 'en';
    for (let j = i; j >= 0; j--) {
      if (lines[j].match(/^\s+([a-zA-Z_]+):\s+\{/)) {
        lang = lines[j].match(/^\s+([a-zA-Z_]+):\s+\{/)[1];
        if (docsTranslations[lang]) break;
      }
    }
    
    if (docsTranslations[lang]) {
      const t = docsTranslations[lang];
      // Insert docs before footer
      lines.splice(i, 0, 
        `    docs: {`,
        `      intro_title: "${t.intro_title}",`,
        `      intro_desc: "${t.intro_desc}",`,
        `      gui_title: "${t.gui_title}",`,
        `      gui_desc: "${t.gui_desc}",`,
        `      safe_title: "${t.safe_title}",`,
        `      safe_desc: "${t.safe_desc}",`,
        `      preview_title: "${t.preview_title}"`,
        `    },`
      );
      i += 10;
    }
  }
}

fs.writeFileSync('app/translations.ts', lines.join('\n'));
console.log("Docs translations added successfully!");
