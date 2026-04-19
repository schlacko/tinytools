# 🧰 tinytools

A random collection of small shell scripts I use daily.

Built around a minimal Linux setup with:

* rofi
* polybar
* window managers like i3 / openbox
* and a lot of "good enough" bash

---

## ⚠️ Vibe Coding Warning

This repo is 100% vibe-coded.

Scripts were written:

* quickly
* for my own setup
* without portability in mind

You will find:

* hardcoded paths
* missing checks
* janky logic
* pure trial-and-error solutions

If it breaks → it's working as intended.

---

## ✨ What’s inside?

Small utilities like:

* 🚀 rofi launchers
* 🔌 power menu
* ⏱ polybar usage/time tracker
* 🍅 simple pomodoro timer
* 🌐 quick network helpers
* 📸 screenshot scripts
* and other tiny hacks

Each script solves one specific problem. Nothing more.

---

## ⚙️ Dependencies

Most scripts rely on the following tools being installed:

### Core

* `bash`
* `rofi`
* `polybar`
* `notify-send`

### System / WM

* `i3` or `openbox`
* `setxkbmap`

### Utilities

* `curl`
* `wget`
* `scrot`
* `dmenu`

### Arch-specific (optional)

* `checkupdates`

👉 Not all scripts need all dependencies.
👉 If something breaks, open the script and see what it expects.

---

## 🚀 Usage

No unified interface.

Most scripts are just:

```bash
./script.sh
```

Others are meant to be:

* triggered from polybar
* bound to hotkeys
* used inside rofi menus

---

## 🛠 Setup

If you actually want to use this:

1. Clone the repo
2. Pick a script
3. Read it (seriously)
4. Fix:

   * paths
   * commands
   * assumptions
5. Integrate it into your setup

Examples:

* bind to a key in i3
* call from polybar module
* wrap in rofi menu

---

## 🧠 Philosophy

* small > complex
* fast > clean
* working > correct

These scripts exist to remove tiny annoyances from daily workflow.

Nothing here is meant to be perfect.

---

## 🤝 Contributing

Not really the point of this repo, but:

* PRs are welcome
* improvements are cool
* overengineering is not

---

## 📜 License

Do whatever you want with this.

No guarantees, no promises.

