# 🚀 Linux Bash Theme
---

## ✨ Features

- CPU / RAM / DISK stats
- Color-coded UI (cyan, green, yellow, red)
- Root detection (red username)
- Normal user detection (green username)

---

## 📦 Normal User Theme Installation

### 1. Clone the repository

```bash
git clone https://github.com/devsjayanth/Linux-Bash-Theme.git
````

---

### 2. Enter the folder

```bash
cd Linux-Bash-Theme
chmod +x install.sh
./install.sh
```

---

### 4. Apply changes

```bash
source ~/.bashrc
```

or

```bash
exec bash
```

---

## 👑 Root User theme Installation

After normal install, switch to root and apply again:

```bash
sudo su
cd Linux-Bash-Theme
./install.sh
source /root/.bashrc
```

or simply:

```bash
sudo su
./install.sh
source ~/.bashrc
```

---

## 🔁 Apply for all users

Run install again for each user:

```bash
./install.sh
```

Then reload:

```bash
source ~/.bashrc
```

---

## 🎨 Color Scheme

* Username → green (user) / red (root)
* Host → cyan
* Directory → green
* CPU / RAM / DISK labels → cyan
* Percentages → green
* Time → yellow
* Pipe → red
* Frame + arrow → cyan

---

## ⚠️ Notes

* No sudo required for normal install
* Only modifies `~/.bashrc`
* Safe for production servers
* Compatible with Bash 4+

---

## 🧹 Uninstall

Remove this block from:

```bash
nano ~/.bashrc
```

Then delete:

```text
# ===== Bash Theme V9 =====
```

Reload:

```bash
source ~/.bashrc
```

---

## 🚀 Quick Fix

If prompt does not update:

```bash
exec bash
```

````

---

# ⚡ Important improvement I made (based on best practices)

Instead of blindly relying on:
```bash
sudo su
````

I structured it correctly:

* install per-user (safe)
* root install explicitly
* no automatic sudo prompts inside script (prevents breakage on servers)

---

# If you want next upgrade

I can help you turn this repo into a **real CLI tool like:**

```bash
bash-theme install
bash-theme uninstall
bash-theme root
```

or even:

```bash
curl -sSL install.sh | bash
```

Just tell me 👍
