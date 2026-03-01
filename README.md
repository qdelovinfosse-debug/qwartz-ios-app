# Qwartz iOS 📱

Application iOS native pour **QWARTZ ENGINE** — moteur de recherche de torrents avec indicateurs de sécurité.

## Fonctionnalités
- 🔍 Recherche via l'API apibay.org
- 🟢 Badges de sécurité (TRÈS SAFE / SAFE / NON VÉRIFIÉ)
- 🧲 Ouverture directe du lien magnet dans ton client torrent iOS
- 📋 Copie du lien magnet en un tap
- ⚡ Tri par sécurité puis par nombre de seeders
- 🌑 Design sombre identique à la version web

## Prérequis
- macOS avec Xcode 15+ installé
- iPhone sous iOS 16+
- Un compte Apple (gratuit suffit pour installer en local)

## Installation sur l'iPhone

### 1. Cloner le repo
```bash
git clone https://github.com/<ton-pseudo>/qwartz-ios.git
cd qwartz-ios
```

### 2. Générer le projet Xcode
```bash
brew install xcodegen   # si pas encore installé
xcodegen
```
Cela génère `Qwartz.xcodeproj`.

### 3. Ouvrir dans Xcode et installer sur l'iPhone
```bash
open Qwartz.xcodeproj
```
- Branche ton iPhone en USB
- Dans Xcode, sélectionne ton iPhone comme cible
- Dans **Signing & Capabilities**, choisis ton Apple ID (compte gratuit OK)
- Appuie sur ▶ pour build & installer

> Avec un compte gratuit, le certificat expire après **7 jours** — il suffit de re-builder.
> Avec un compte développeur Apple ($99/an) le certificat dure 1 an.

### 4. Faire confiance à l'app sur l'iPhone
`Réglages → Général → VPN et gestion des appareils → [ton Apple ID] → Faire confiance`

## Structure du projet

```
qwartz-ios/
├── project.yml                  # Config XcodeGen
├── Qwartz/
│   ├── QwartzApp.swift          # Point d'entrée
│   ├── ContentView.swift        # Vue principale (recherche + résultats)
│   ├── Models/
│   │   └── TorrentItem.swift    # Modèles de données
│   ├── Services/
│   │   └── TorrentService.swift # Appels API apibay.org
│   ├── Views/
│   │   ├── ResultRowView.swift  # Carte résultat
│   │   └── SafetyBadge.swift   # Badge sécurité
│   ├── Assets.xcassets/
│   └── Info.plist
└── README.md
```

## Client torrent recommandé pour iOS
Pour que le bouton **TÉLÉCHARGER** fonctionne, installe un client torrent compatible avec les liens magnets :
- [qBittorrent Remote](https://apps.apple.com/fr/app/qbittorrent-remote/id1458225885)
- [Infuse 7](https://apps.apple.com/fr/app/infuse-7/id1136220934)
- [iTorrent](https://github.com/XITRIX/iTorrent) (via AltStore)
