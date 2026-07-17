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
```

Make the command executable:

```bash
chmod +x bin/twp
```

Run the command:

```bash
./bin/twp
```

## Configuration

Provider configurations are stored locally under:

```text
providers/
```

Example layout:

```text
providers/
├── custom/
├── proton/
│   ├── examples/
│   └── us.conf
```

Private WireGuard configuration files are intentionally excluded from Git tracking.

Configure `configs/wireproxy.conf`:

```ini
WGConfig = /path/to/provider/profile.conf

[Socks5]
BindAddress = 127.0.0.1:25344
```

## Commands

### Start WireProxy

```bash
twp start
```

### Stop WireProxy

```bash
twp stop
```

### Restart WireProxy

```bash
twp restart
```

### Check Status

```bash
twp status
```

### Health Check

```bash
twp health
```

### Diagnose Problems

```bash
twp doctor
```

### Show Current Configuration

```bash
twp current
```

### Show VPN Exit IP

```bash
twp ip
```

### View Logs

```bash
twp logs
```

Follow logs:

```bash
twp logs -f
```

### List Providers

```bash
twp providers
```

### Change Provider Profile

```bash
twp use <provider> <profile>
```

Example:

```bash
twp use proton us.conf
```

### Show Version

```bash
twp version
```

## Security

Sensitive files are intentionally excluded from version control.

Ignored files include:

```text
providers/**/*.conf
logs/
state/
```

Do **not** upload private WireGuard configuration files, private keys, or VPN credentials.

## Project Status

Current version:

```
0.1.0-alpha
```

This project is currently under active development.

## License

License information will be added before the first public release.
