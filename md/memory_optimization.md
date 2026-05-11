# Memory Optimization - Android Studio Performance

**Date:** 2026-05-11

---

## Problem

System was slow when running Android Studio and Flutter emulator despite having 16GB RAM.

## Diagnosis

| Metric | Before | After |
|--------|--------|-------|
| RAM used | 10 GB | 7.2 GB |
| RAM free | 2.3 GB | 4.8 GB |
| Swap used | 3.9 GB | 2.7 GB |

**Root cause:** Too many heavy apps running simultaneously, causing heavy swap usage (disk instead of RAM = slow).

## Memory Hogs Identified

- Gradle daemon: ~2 GB
- 5x Claude instances (only 2 needed): ~3 GB
- JetBrains Toolbox (unused): ~360 MB
- VS Code: ~1.5 GB
- Firefox: ~250 MB

## Actions Taken

1. **Killed JetBrains Toolbox** (unused app)
   ```bash
   pkill -f "jetbrains-toolbox"
   ```

2. **Removed JetBrains Toolbox completely**
   ```bash
   rm -rf ~/.local/share/JetBrains
   rm -f ~/.config/autostart/jetbrains-toolbox.desktop
   ```

3. **Killed old Claude processes** (4 orphaned sessions)
   ```bash
   kill 28616 38032 70850 76012
   ```

## Result

Freed ~3GB RAM. Swap usage dropped significantly. Android Studio and emulator now run smoothly.

## Lesson Learned

16GB RAM is enough for Android Studio + emulator, but avoid running too many heavy apps (multiple IDEs, browser tabs, background processes) at the same time.

## Useful Commands

```bash
# Check memory
free -h

# Find memory-hungry processes
ps aux --sort=-%mem | head -10

# Kill Gradle daemon (if not building)
pkill -f GradleDaemon

# Check running emulators
flutter devices
```
