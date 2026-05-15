# Dev Setup: Credential Freshness & Session Persistence

## Overview

All development happens on Cloud Desktop (`dev-dsk-bhadarsh-2a-bd6bf107.us-west-2.amazon.com`). This setup ensures:
- Midway, Kerberos, and SSH keys stay fresh automatically
- Terminal sessions survive laptop sleep via tmux

---

## What's Configured (Cloud Desktop)

| File | Purpose |
|------|---------|
| `~/.tmux.conf` | tmux config (mouse, 50k scrollback, split shortcuts) |
| `~/bin/refresh-creds.sh` | Auto-refreshes Midway + Kerberos + SSH agent |
| `crontab` (every 8h) | Runs `refresh-creds.sh` silently |
| `~/.zshrc` additions | Lazy cred check on shell open + tmux auto-attach on SSH login |
| `~/.ssh/config` | ServerAliveInterval 30s keepalive |

---

## One-Time Setup (Cloud Desktop)

Bootstrap credentials with a renewable Kerberos ticket:

```bash
kinit -f -r 7d
mwinit -o -s
```

The `-r 7d` makes the ticket renewable for 7 days so the cron auto-renewal (`kinit -R`) works without a password.

---

## Laptop (iTerm2) Setup

### ~/.ssh/config (on Mac)

```ssh-config
Host cloud-desktop
  HostName dev-dsk-bhadarsh-2a-bd6bf107.us-west-2.amazon.com
  User bhadarsh
  ServerAliveInterval 30
  ServerAliveCountMax 3
  TCPKeepAlive yes
```

### iTerm2 Profile

In **iTerm2 > Profiles > Default > General > Command**, set:
- **Command:** `ssh cloud-desktop`

Or create a profile called "Cloud Desktop" with:
- **Command:** `ssh cloud-desktop -t 'tmux attach -t main || tmux new -s main'`

This auto-connects and reattaches to your persistent tmux session.

---

## Daily Workflow

| When | What Happens |
|------|--------------|
| Open laptop / iTerm2 tab | SSH connects, auto-attaches to tmux `main` — sessions still running |
| Every 8 hours (cron) | Midway + Kerberos auto-refreshed silently |
| Open a new tmux window | Lazy check refreshes creds if stale |
| **Once a week** | Run `kinit -f -r 7d` (renewable ticket max is 7 days) |

### The only manual command needed:

```bash
# Once a week (on Cloud Desktop)
kinit -f -r 7d
```

---

## tmux Cheat Sheet

| Action | Keys |
|--------|------|
| New window | `Ctrl-b c` |
| Switch windows | `Ctrl-b 1`, `Ctrl-b 2`, ... |
| Split horizontally | `Ctrl-b -` |
| Split vertically | `Ctrl-b \|` |
| Switch panes | `Ctrl-b arrow` |
| Detach (leave running) | `Ctrl-b d` |
| Reattach | `tmux attach -t main` |
| Scroll mode | `Ctrl-b [` (then arrow/pgup, `q` to exit) |
| Kill pane | `Ctrl-b x` |
| Rename window | `Ctrl-b ,` |
| List sessions | `tmux ls` |
| Reload config | `Ctrl-b r` |

---

## Troubleshooting

### Credentials still expiring?

```bash
# Check Kerberos ticket status
klist

# Check Midway cookie age
ls -la ~/.midway/cookie

# Manual full refresh (your existing alias)
creds

# Or just the refresh script
~/bin/refresh-creds.sh
```

### tmux session not auto-attaching?

```bash
# Check if tmux is running
tmux ls

# Manually attach
tmux attach -t main

# If no session exists, create one
tmux new-session -s main
```

### Cron not running?

```bash
# Check cron logs
grep cred-refresh /var/log/syslog 2>/dev/null || journalctl -t cred-refresh

# Verify crontab
crontab -l
```

---

## Files Modified (for reference)

- `~/.zshrc` — added ssh-agent persistence, lazy cred check, tmux auto-attach block
- `~/.ssh/config` — added `Host *` keepalive settings
- `~/.tmux.conf` — created (full config)
- `~/bin/refresh-creds.sh` — created (cron script)
- `crontab` — added 8-hour refresh entry
