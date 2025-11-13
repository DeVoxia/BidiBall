# 🪩 BidiBall

**BidiBall** est un jeu de billes colorées développé sous **Godot 4.x**, dont l’objectif est de remplir les réservoirs correspondants sans se tromper de couleur.  
Le gameplay se veut rapide, addictif et visuellement clair.

---

## 🧠 Objectif du projet

Chaque bille doit :
- être envoyée dans le réservoir de **la même couleur**,
- éviter les erreurs (une bille dans le mauvais réservoir réduit le score),
- remplir chaque jauge au niveau cible.

---

## ⚙️ Environnement de développement

| Outil | Version | Rôle |
|--------|----------|------|
| **Godot Engine** | 4.x | Moteur principal du jeu |
| **VS Code / Cursor** | Dernière version stable | Éditeur de code GDScript |
| **Git** | 2.4+ | Versionning du code |
| **Git LFS** | activé | Gestion des assets lourds |
| **GitHub** | [DeVoxia/BidiBall](https://github.com/DeVoxia/BidiBall) | Hébergement du dépôt |
| **OpenAI Codex / ChatGPT** | GPT-5 | Aide à la génération de code et documentation |

---

## 🏗️ Structure du projet

```
BidiBall/
│
├── project.godot                # Fichier principal du projet Godot
├── scenes/                      # Scènes du jeu
│   ├── Main.tscn
│   ├── Game.tscn
│   ├── Marble.tscn
│   └── Reservoir.tscn
├── scripts/                     # Scripts GDScript
│   ├── Game.gd
│   ├── Marble.gd
│   ├── Reservoir.gd
│   └── Globals.gd
├── assets/                      # Ressources visuelles et audio
│   ├── sprites/
│   ├── fonts/
│   └── sfx/
├── .gitignore
├── .gitattributes
└── README.md
```

---

## 💻 Installation locale

### 1️⃣ Cloner le projet

```bash
git clone https://github.com/DeVoxia/BidiBall.git
cd BidiBall
```

### 2️⃣ Ouvrir le projet dans Godot
- Lancer **Godot 4.x**
- Cliquer sur **Import Project**
- Sélectionner le fichier :
  ```
  project.godot
  ```

### 3️⃣ Ouvrir dans VS Code
```bash
code .
```

### 4️⃣ Lancer le jeu
Dans Godot → **F5**  
Le jeu démarre avec la scène `Main.tscn`.

---

## 🔁 Collaboration & multi-machine

Pour travailler depuis une autre machine :

```bash
git clone https://github.com/DeVoxia/BidiBall.git
cd BidiBall
```

Ensuite :
| Action | Commande |
|---------|-----------|
| Mettre à jour ton clone | `git pull` |
| Pousser tes changements | `git push` |
| Créer une branche de dev | `git checkout -b dev` |

> ⚠️ Assure-toi d’être connecté à ton compte GitHub (`gh auth login` ou SSH).

---

## 📦 Git LFS

Les fichiers binaires (images, sons, sprites, etc.) sont stockés via **Git LFS**.

Vérifie qu’il est actif :

```bash
git lfs install
git lfs track "*.png" "*.jpg" "*.wav" "*.ogg" "*.ttf"
```

---

## 🧩 Bonnes pratiques

- **Ne commit pas** de fichiers dans `.import/`, `.export/`, `bin/`, `dist/`.
- **Crée une branche par feature** (ex : `feature-ui`, `fix-collision`).
- **Teste dans Godot** avant chaque push (`F5`).
- **Documente** tes scripts (docstrings GDScript).
- **Utilise Codex / ChatGPT** pour générer ou expliquer du code.

---

## 🎯 Feuille de route

| Étape | Statut | Description |
|--------|--------|-------------|
| 🔹 Initialisation Godot + GitHub | ✅ | Projet de base et configuration |
| 🔹 Scène de jeu & scripts principaux | 🟡 | En cours |
| 🔹 Mécanique des billes / collisions | ⏳ | À implémenter |
| 🔹 Interface de score et jauges | ⏳ | À concevoir |
| 🔹 Export PC & Mobile | 🔜 | À préparer |

---

## 📄 Licence
Projet personnel © 2025 – **Jérôme Vignot (DeVoxia)**  
Utilisation libre pour usage privé / expérimental.  
Contact : `dev.voxia@gmail.com`
