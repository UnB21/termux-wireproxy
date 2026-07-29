# Troubleshooting Guide

## IPv6 WireGuard Profiles Causing HTTPS Connection Failures

### Symptoms

WireProxy may appear to be working correctly:

- `twp doctor` reports READY
- WireProxy is running
- SOCKS5 proxy responds
- Exit IP checks succeed

However:

- HTTP websites load normally
- HTTPS websites may fail, hang, or never finish loading
- Browsers may appear stuck while connecting

Example error:

TLS connect error: unexpected eof while reading

---

## Cause

Some WireGuard profiles include both IPv4 and IPv6 routing:

```ini
AllowedIPs = 0.0.0.0/0, ::/0
This enables all IPv4 and IPv6 traffic through the VPN.
On some Android + Termux + WireProxy environments, IPv6 routing may cause TLS/HTTPS connection failures even though the VPN tunnel and SOCKS5 proxy are functioning.

Solution:
Use an IPv4-only WireGuard profile.
The peer configuration should contain:
AllowedIPs = 0.0.0.0/0
instead of:
AllowedIPs = 0.0.0.0/0, ::/0

Activate the profile:
twp use <provider> <profile>
twp restart

Verify:
twp doctor
twp ip

Test HTTPS:
curl --socks5-hostname 127.0.0.1:25344 https://example.com

Diagnostic Process

The issue was isolated by testing each layer:

Confirm WireProxy status:
twp doctor

Confirm SOCKS5 connectivity:
curl --socks5-hostname 127.0.0.1:25344 http://example.com

Test HTTPS/TLS:
curl -v --socks5-hostname 127.0.0.1:25344 https://example.com

Replace the WireGuard profile with an IPv4-only configuration.
After switching profiles, HTTPS connections worked normally.

Notes:

IPv6 support may be added or improved in future versions.

For maximum compatibility on Android Termux environments, IPv4-only WireGuard profiles are recommended.
