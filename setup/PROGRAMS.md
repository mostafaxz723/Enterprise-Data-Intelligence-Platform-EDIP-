# البرامج المطلوبة (كلها مجانية)

**ركّبي مرة واحدة، وأعيدي فتح PowerShell بعد التركيب.** ما يخص كل دور:

| البرنامج | ليه؟ | web (واجهة) | data (بيانات) | رابط |
|---|---|:-:|:-:|---|
| **Git** | نسخ الريبو والعمل الجماعي | ✔ | ✔ | git-scm.com |
| **GitHub Desktop** (اختياري) | أسهل من أوامر Git | ✔ | ✔ | desktop.github.com |
| **VS Code** | المحرر | ✔ | ✔ | code.visualstudio.com |
| **Node.js (LTS)** | تشغيل الموقع | ✔ | | nodejs.org |
| **Anaconda** | بيئة Python والمكتبات | | ✔ | anaconda.com/download |
| **Docker Desktop** | قواعد البيانات والخدمات | | ✔ | docker.com |
| **QGIS** | مراجعة طبقات الخرائط | | ✔ | qgis.org |
| **DBeaver** (اختياري) | تصفح قاعدة البيانات | | ✔ | dbeaver.io |
| **Ollama** (اختياري) | نموذج لغوي مجاني للمساعد | | ✔ | ollama.com |

## تركيبها بأمر واحد (ويندوز 11، winget)
```powershell
winget install --id Git.Git -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id Anaconda.Anaconda3 -e
winget install --id Docker.DockerDesktop -e
winget install --id OSGeo.QGIS -e
winget install --id Ollama.Ollama -e
```
(أو شغّلي `setup\install-programs.ps1` وهو يركّب الناقص فقط. لو اسم حزمة اتغير استخدمي `winget search <الاسم>`.)

## من يحتاج إيه؟
- **جهاز 8 جيجا أو أقل:** دور **web** فقط (Git + VS Code + Node). الموقع يشتغل بالبيانات التجريبية بدون Docker ولا Anaconda.
- **جهاز 16 جيجا:** دور **data** أو **all**.
- **Linux / Mac:** نفس البرامج. والتجهيز بـ `bash setup/bootstrap.sh --role all`.
- **ويندوز + WSL2:** Docker Desktop بيستخدمه تلقائيًا، ومش لازم تركيب Ubuntu.
