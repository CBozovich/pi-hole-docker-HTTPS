# Pi-hole on Raspberry Pi with Docker & HTTPS

This project deploys [Pi-hole](https://pi-hole.net/) on a Raspberry Pi using Docker, with a secure self-signed HTTPS admin interface and custom blocklists.

## Features
Runs Pi-hole in a Docker container for easy management  
Assigns a static IP on the LAN (e.g., `192.168.1.137`)  
Uses `host` networking for compatibility with Wi-Fi  
Enables HTTPS on the Pi-hole admin portal using self-signed certificates  
Adds curated blocklists for ads, trackers, malware, and more  
Automatically starts on boot

## Tech Stack
- Raspberry Pi OS (Debian-based)
- Docker + Docker Compose
- Pi-hole
- lighttpd webserver
- OpenSSL (for self-signed certs)

## Installation

See the full guide in the README above or in the repository.
