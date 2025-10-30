# CUPS & SANE AIO Docker Image for Panasonic KX-MB1500 Series

This project provides a ready-to-use container image for printing and scanning with Panasonic KX-MB1500 series multifunction devices. It combines:

- **CUPS** – for print sharing (with Panasonic printer drivers)
- **SANE** – for network scanning (with Panasonic scan drivers)
- **scanservjs** – modern web UI for scanning
- S6-overlay – easy process supervision for containers

---

## ⚠️ Intended Architecture

- **Built for x86_64 Linux userland.**
- **Designed to run on ARM64 (e.g. Raspberry Pi, ARM SBCs) hosts with [`qemu-user-static`](https://github.com/multiarch/qemu-user-static).**
- Enables use of proprietary x86_64 printer and scanner drivers on non-x86 hardware.

---

## Features
- Panasonic KX-MB1500 print (GDI driver installed)
- Panasonic KX-MB1500 scan (proprietary SANE driver installed)
- scanservjs for web-based scanning and management
- CUPS web interface for printer administration
- SANE network scanner sharing
- Configurable via mounted config files

## Usage

**You must register QEMU and run the container with binfmt_misc enabled on ARM64:**

```bash
# Set up QEMU (on the host, runs once)
sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
# Then run the image (example, adjust volumes & ports as needed)
docker run -d \
  --name=cups-sane-aio \
  --device /dev/bus/usb:/dev/bus/usb \
  -p 631:631 -p 8190:8190 \
  -e CUPS_ADMIN_USER=printer -e CUPS_ADMIN_PASSWORD=printer \
  ghcr.io/rma945/mb1500-mfp:v1.0.0
```

### Volumes and Configuration

- `/etc/cups/` and `/etc/sane.d/` – for advanced config
- `/opt/scanserver/config/` – scanservjs config override
- `/opt/scanserver/data` – scanservjs application data folder

For example, to persist config:
```
-v /my/cupsd.conf:/etc/cups/cupsd.conf \
-v /my/printers.conf:/etc/cups/printers.conf
```

---

## Ports
- 8190 (TCP): scanservjs web UI
- 631 (TCP): CUPS

---

## Notes
- The default printer admin username/password: `printer` / `printer`
- Designed for Panasonic KX-MB1500, may be adaptable to other GDI devices

---

## References
- [Panasonic Linux Printer and Scan Drivers](https://www.psn-web.net/cs/support/fax/common/linux_driver.html)
- [scanservjs](https://github.com/sbs20/scanservjs)
- [CUPS](https://openprinting.github.io/cups/)
- [QEMU User Static](https://github.com/multiarch/qemu-user-static)

---
