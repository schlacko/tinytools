# 🧰 tinytools

A random collection of small shell scripts I use daily.

Mostly built around:

* rofi
* polybar
* bash
* and whatever else was installed at the time

---

## ⚠️ Vibe Coding Warning

This repo is 100% vibe-coded.

Scripts were written:

* quickly
* for my own setup
* with zero intention of being portable

You will find:

* hardcoded paths
* missing error handling
* questionable decisions
* "I'll fix this later" energy

If something breaks → that's expected.

---

## ✨ What’s inside?

A bunch of tiny utilities, for example:

* 🚀 rofi app launchers
* 🔌 power menu (shutdown, reboot, etc.)
* ⏱ polybar time tracking / usage counter
* 🍅 a minimal pomodoro timer
* 🔊 small system helpers
* …and other random scripts

Nothing here is big or complex — just small tools that make everyday usage smoother.

---

## ⚙️ Requirements

Most scripts assume you have:

* `bash`
* `rofi`
* `polybar`
* `notify-send`
* standard Linux utilities

Some scripts may also depend on:

* `playerctl`
* `amixer` / `pactl`
* `xrandr`
* etc.

👉 If something doesn’t work, check the script.

---

## 🚀 Usage

There is no unified interface.

Most scripts are just:

```bash
./script.sh
```

Some are meant to be:

* called from polybar
* bound to hotkeys
* launched via rofi

---

## 🛠 Setup (if you really want to use this)

1. Clone the repo
2. Open the scripts you care about
3. Fix:

   * paths
   * commands
   * configs
4. Plug them into your setup

Example:

* bind a script to a key in your WM
* call it from polybar
* hook it into rofi

---

## 🧠 Philosophy

Small > big
Simple > perfect
Working > correct

These scripts exist to:

* save a few seconds
* reduce friction
* automate annoying stuff

That’s it.

---

## 🤝 Contributing

Not really the goal, but if you:

* improve something
* fix a bug
* or have a cool tiny script

feel free to open a PR.

---

## 📜 License

Use whatever you want, break whatever you want.

No guarantees.
