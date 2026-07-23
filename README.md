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

Enter the project directory you just cloned:

```bash
cd termux-wireproxy
```

If you cloned the repository using a different directory name, enter that directory instead.

Example:

```bash
cd termux-wireproxy-test
```

You can verify your current working directory at any time by running:

```bash
pwd
```

Example output:

```text
/data/data/com.termux/files/home/<your-project-directory>
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

## Understanding the Project Layout

After installation, all project files are stored inside the directory you cloned.

To see the project files, run:

```bash
ls
```

You should see folders similar to:

```text
bin
configs
lib
logs
providers
scripts
state
```

The most important directories are:

| Directory | Purpose |
|-----------|---------|
| `providers/` | Stores your private WireGuard configuration files |
| `configs/` | Project configuration files |
| `scripts/` | Internal scripts used by the `twp` command |
| `logs/` | WireProxy log files |
| `state/` | Runtime state information |

All commands shown throughout this guide should be run from inside the project directory unless stated otherwise.

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

A WireGuard profile is a configuration file supplied by your VPN provider or generated for your own WireGuard server.

The file usually has a `.conf` extension and contains information such as:

- Interface private key
- VPN address
- Server public key
- Server endpoint
- Allowed IP addresses

Example filename:

```text
us.conf
```

Create a directory for your VPN provider:

```bash
mkdir -p providers/proton
```

Verify that the directory was created:

```bash
ls providers
```

Expected output:

```text
proton
```

At this point, the provider directory exists but is empty.

Your WireGuard configuration file must be copied into that directory before it can be used.

Never upload your WireGuard configuration file to GitHub or share it publicly.

Your WireGuard profile contains private cryptographic keys and should be treated like a password.

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

## Copying Your WireGuard Configuration into Termux

If you downloaded your WireGuard configuration using your Android web browser, it is usually saved in your Downloads folder.

To allow Termux to access Android storage, run:

```bash
termux-setup-storage
```

When prompted, grant the requested storage permission.

Your Downloads folder will then be available at:

```text
~/storage/downloads
```

List the downloaded files:

```bash
ls ~/storage/downloads
```

If your configuration file is named `us.conf`, copy it into your provider directory:

```bash
cp ~/storage/downloads/us.conf providers/proton/
```

Verify that it was copied successfully:

```bash
ls providers/proton
```

Expected output:

```text
us.conf
```

Your WireGuard configuration is now ready to be selected by Termux WireProxy.

---

## Available Providers

List available provider profiles:

```bash
twp providers
```

---

## Selecting a Provider Profile

The `twp use` command expects two arguments:

```text
twp use <provider> <profile>
```

- `<provider>` is the name of the directory inside `providers/`
- `<profile>` is the name of the WireGuard configuration file

For example, if your project looks like this:

```text
providers/
└── proton/
    └── us.conf
```

Run:

```bash
twp use proton us.conf
```

Another example:

```text
providers/
└── myserver/
    └── home.conf
```

Run:

```bash
twp use myserver home.conf
```

After selecting a profile, verify the active configuration:

```bash
twp current
```

---

## Quick Start Example

The following example demonstrates a complete first-time setup after installation.

Create a provider directory:

```bash
mkdir -p providers/myvpn
```

Copy your WireGuard configuration file into that directory:

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

Check that WireProxy is running:

```bash
twp status
```

Verify your VPN exit IP:

```bash
twp ip
```

If everything is configured correctly, your public IP address should now be the IP address of your VPN server or VPN provider.

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

### `twp: command not found`

Run the installer again:

```bash
./install.sh
```

Then verify:

```bash
twp version
```

---

### WireProxy is missing

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

### Provider profile missing

This usually means Termux WireProxy could not find the WireGuard configuration file it expects.

First, list your provider directories:

```bash
ls providers
```

Then list the profiles inside your provider directory:

```bash
ls providers/proton
```

Verify the currently selected configuration:

```bash
twp current
```

If you selected the wrong provider or profile, activate the correct one:

```bash
twp use <provider> <profile>
```

Example:

```bash
twp use proton us.conf
```

---

### WireProxy will not start

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

### SOCKS5 proxy unavailable

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
