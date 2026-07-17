# Termux WireProxy

A lightweight WireGuard-over-SOCKS5 management wrapper for Termux.

Termux WireProxy provides a simple command-line interface (`twp`) for managing a Wireproxy-based VPN SOCKS5 proxy connection on Android using Termux.

The project is designed to make starting, stopping, checking, and troubleshooting Wireproxy easier from a mobile Linux environment.

## Features

- Simple `twp` command interface
- Provider/profile management
- Start, stop, and restart Wireproxy
- Process and connection health checks
- Current configuration display
- VPN exit IP verification
- Log viewing and follow mode
- Version reporting
- Separation of public project files and private VPN credentials

## Requirements

- Android device
- Termux
- Wireproxy
- A WireGuard-compatible VPN provider configuration

## Installation

Clone the repository:

```bash
git clone <repository-url>
cd termux-wireproxy
