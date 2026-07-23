# Termux WireProxy

A lightweight WireGuard-over-SOCKS5 management wrapper for Termux.

Termux WireProxy provides a simple command-line interface (`twp`) for managing a WireProxy-based VPN SOCKS5 proxy connection on Android using Termux.

The goal of this project is to make WireProxy easier to install, configure, start, stop, monitor, and troubleshoot from a mobile Linux environment.

---

## Features

- Simple `twp` command interface
- Automatic WireProxy dependency installation
- Provider/profile management
- Start, stop, and restart WireProxy
- Process and connection health checks
- Active configuration display
- VPN exit IP verification
- Log viewing and follow mode
- Version reporting
- Separation of public project files and private VPN credentials

---

## Requirements

Before installing, you need:

- Android device
- Termux
- A WireGuard-compatible VPN configuration file

Termux WireProxy uses:

- **WireProxy** to create a local SOCKS5 proxy from a WireGuard connection.
- **WireGuard configuration files** provided by your VPN provider or your own WireGuard server.

Your WireGuard configuration file contains private information such as cryptographic keys and should never be shared publicly.

---

## Installation

### 1. Clone the repository

Install Git if needed:

```bash
pkg install git
```

Clone the project:

```bash
git clone https://github.com/UnB21/termux-wireproxy.git
```

Enter the project directory:

```bash
cd termux-wireproxy
```

---

### 2. Run the installer

Run:

```bash
./install.sh
```

The installer will:

- Verify it is running inside Termux
- Install WireProxy if it is missing
- Make the `twp` command executable
- Create the Termux command shortcut

After installation, verify:

```bash
twp version
```

Expected output:

```text
Termux WireProxy
Version: 0.1.0-alpha
```

Run diagnostics:

```bash
twp doctor
```

---

## First-Time Configuration

Termux WireProxy uses provider profiles.

A provider profile is a WireGuard configuration file stored inside the `providers` directory.

The expected layout is:

```text
providers/
└── provider-name/
    └── profile-name.conf
```

Example:

```text
providers/
└── proton/
    └── us.conf
```

---

## Adding a WireGuard Profile

Your VPN provider should provide a WireGuard configuration file.

The file normally contains:

- Interface private key
- VPN address
- Server public key
- Server endpoint
- Allowed IP addresses

Example filename:

```text
us.conf
```

Create a provider directory:

```bash
mkdir -p providers/proton
```

Place your configuration file:

```text
providers/proton/us.conf
```

Do not upload this file to GitHub or share it publicly.

Your WireGuard profile contains private keys and should be treated like a password.

---

## Getting a WireGuard Configuration File

Termux WireProxy requires a WireGuard client configuration file that connects to an existing WireGuard server.

There are two common ways to obtain one.

---

## Option 1: Use a VPN Provider (Recommended)

Many VPN providers allow downloading WireGuard configuration files from their account dashboard.

This is the easiest option because the provider already operates the WireGuard server.

---

## Option 2: Create Your Own WireGuard Server

If you want to host your own VPN server, you can generate WireGuard configurations using tools such as:

- Nixpoin WireGuard Config Generator
  https://nixpoin.com/wireguard-generator/

- ServerSpan WireGuard Generator
  https://www.serverspan.com/en/tools/wireguard

These tools generate server and client configuration files.

You will still need:

- A VPS or server
- A public IP address
- A WireGuard server installation

A configuration generator does not create a VPN service by itself.

After generating your client configuration file, place it in:

```text
providers/<provider>/<profile>.conf
```

Example:

```text
providers/myserver/home.conf
```

Then activate it:

```bash
twp use myserver home.conf
```

Prefer tools that generate private keys locally and do not transmit private keys to third parties. Review the privacy information of any generator before trusting it with cryptographic material.

---

## Available Providers

List available provider profiles:

```bash
twp providers
```

---

## Selecting a Provider Profile

After adding your profile, select it:

```bash
twp use <provider> <profile>
```

Example:

```bash
twp use proton us.conf
```

This updates the active WireProxy configuration.

Check the current selection:

```bash
twp current
```

Example output:

```text
Provider:
proton

Profile:
us.conf

SOCKS5:
127.0.0.1:25344
```

---

## Quick Start Example

After installation, a complete first connection setup may look like this.

Create a provider directory:

```bash
mkdir -p providers/myvpn
```

Place your WireGuard configuration file:

```text
providers/myvpn/home.conf
```

Select the profile:

```bash
twp use myvpn home.conf
```

Verify the active configuration:

```bash
twp current
```

Run diagnostics:

```bash
twp doctor
```

Start WireProxy:

```bash
twp start
```

Check the connection:

```bash
twp status
```

Verify your VPN exit IP:

```bash
twp ip
```

---

## Testing the Connection

Run:

```bash
twp health
```

This checks:

- WireProxy availability
- Configuration validity
- Running process
- SOCKS5 availability

To check your VPN exit IP:

```bash
twp ip
```

---

## Commands

The `twp` command manages WireProxy without requiring you to manually run WireProxy commands.

## Start WireProxy

```bash
twp start
```

## Stop WireProxy

```bash
twp stop
```

## Restart WireProxy

```bash
twp restart
```

## Check Status

```bash
twp status
```

## Health Check

```bash
twp health
```

## Diagnose Problems

```bash
twp doctor
```

## Show Current Configuration

```bash
twp current
```

## Show VPN Exit IP

```bash
twp ip
```

## View Logs

```bash
twp logs
```

Follow logs:

```bash
twp logs -f
```

## List Providers

```bash
twp providers
```

## Change Provider Profile

```bash
twp use <provider> <profile>
```

Example:

```bash
twp use proton us.conf
```

## Show Version

```bash
twp version
```

---

## Troubleshooting

## `twp: command not found`

Run the installer again:

```bash
./install.sh
```

Then verify:

```bash
twp version
```

---

## WireProxy is missing

Run:

```bash
./install.sh
```

The installer will install WireProxy automatically.

You can also verify manually:

```bash
wireproxy --version
```

---

## Provider profile missing

Check your provider folder:

```bash
ls -R providers
```

Confirm your profile exists:

```text
providers/provider-name/profile.conf
```

Then activate it:

```bash
twp use provider-name profile.conf
```

---

## WireProxy will not start

Run:

```bash
twp doctor
```

Then check logs:

```bash
twp logs
```

Restart if needed:

```bash
twp restart
```

---

## SOCKS5 proxy unavailable

If `twp doctor` reports that SOCKS5 is unavailable:

Check status:

```bash
twp status
```

Review logs:

```bash
twp logs
```

Restart WireProxy:

```bash
twp restart
```

---

## Security

Private files are intentionally excluded from Git tracking.

Ignored files include:

```text
providers/**/*.conf
logs/
state/
```

Never upload:

- WireGuard configuration files
- Private keys
- VPN credentials

Treat your WireGuard profile the same way you would treat a password.

---

## Project Status

Current version:

```text
0.1.0-alpha
```

This project is actively under development.

---

## License

This project is licensed under the MIT License.

See the [LICENSE](LICENSE) file for details.
