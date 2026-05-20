# 🚀 Linux Bash Theme

---

## ✨ Features

- CPU / RAM / DISK live stats
- Color-coded UI (cyan, green, yellow, red)
- Root detection (red username)
- Normal user detection (green username)
---
### Backup your current `.bashrc` (IMPORTANT)

Before installing, create a backup:

```bash id="backup1"
cp ~/.bashrc ~/.bashrc.backup
```

## 📦 Installation (Safe Method with Backup)

### 1. Clone repository

```bash
git clone https://github.com/devsjayanth/Linux-Bash-Theme.git
cd Linux-Bash-Theme
```

### 4. Install theme (normal user)

```bash id="install1"
chmod +x install.sh
./install.sh
```

---

### 5. Apply changes

```bash
source ~/.bashrc
```

or:

```bash
exec bash
```

---

## 👑 Root Installation (optional)

If you want the theme for root:

```bash
sudo su
cp /root/.bashrc /root/.bashrc.backup
cd Linux-Bash-Theme
./install.sh
source ~/.bashrc
```

---

## 🔁 Restore original bashrc (rollback option)

If anything goes wrong or you want to revert:

```bash
cp ~/.bashrc.backup ~/.bashrc
source ~/.bashrc
```

For root:

```bash
cp /root/.bashrc.backup /root/.bashrc
source ~/.bashrc
```
---

## 🧹 Uninstall and Restore original bashrc

Restore backup:

```bash
cp ~/.bashrc.backup ~/.bashrc
source ~/.bashrc
```
