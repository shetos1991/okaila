# PS4 13.52 / 14.00 Jailbreak

WebKit + kernel jailbreak host for PlayStation 4 firmware **13.52** and **14.00**. After the stages succeed, the host loads **GoldHEN**.

- **13.52** — classic kpatch path + `patches/1352.bin` (verified on hardware)
- **14.00** — `hx1400` / kevent path + `patches/1400.bin`

## Live host


## Payload

- **GoldHEN v2.4b18.13** (`hen.bin` / `payload.bin`, 297496 bytes)
- sha256 `39452f5e1c305ac9efcb4745eef7958b4db8c6d85299529f08700970b009ea4d`

## How to use

1. Fully power on the console (not Rest Mode).
2. Open the PS4 browser to the live URL (or your LAN host).
3. Press **Start** and wait for the progress bar.
4. On success: **DONE**, then the welcome splash for about 3 seconds.
5. On failure: retry (up to 3 in-page attempts, then reload; up to 10 reloads).

## Local hosting

```powershell
.\start-host.ps1
```

HTTP on port **8080**. On the PS4 browser: `http://<your-pc-lan-ip>:8080/jb.html`

## Credits

- **well0nez / m0zz** - WebKit + kernel exploit chain (afterglow)
- **SiSTR0 / GoldHEN team** - GoldHEN

## Disclaimer

Educational / research use on consoles you own. Use at your own risk.
