# Termux WireProxy v2 - twp init Design

## Purpose

`twp init` is the first-run setup wizard for Termux WireProxy.

The goal is to eliminate manual configuration steps and guide a new user from installation to a working WireProxy connection.

The command should assume the user may have little or no Linux experience.

---

# User Experience Goal

Current workflow:

```
Create directories
Copy WireGuard file
Edit configuration
Understand provider structure
Start WireProxy
Troubleshoot errors
```

Target workflow:

```
Install
 |
 v
twp init
 |
 v
Profile discovered
 |
 v
Configuration generated
 |
 v
Validation complete
 |
 v
twp start
```

---

# Initialization Flow

## Step 1 - Environment Check

Verify:

- Running inside Termux
- Project directory exists
- Required commands available

Checks:

```
✓ Termux detected
✓ Project files found
✓ bash available
```

If Termux is missing:

Explain:

```
This project requires Termux.
Install Termux from the recommended source before continuing.
```

---

# Step 2 - Dependency Check

Check:

```
wireproxy
```

If missing:

Offer:

```
wireproxy is required.

Install now?
[Y/n]
```

Then:

```
pkg install wireproxy
```

---

# Step 3 - Storage Access Check

Check:

```
~/storage
```

If missing:

Display:

```
Termux shared storage access is not enabled.

Run:

termux-setup-storage

Then run:

twp init
```

---

# Step 4 - Search For WireGuard Profiles

Search locations:

```
~/storage/downloads
~/storage/shared/Download
/storage/*/Download
```

Search pattern:

```
*.conf
```

Example:

```
Searching for WireGuard profiles...

Found:

1) us.conf
2) home.conf
3) office.conf
```

---

# Step 5 - Profile Selection

User selects:

```
Select profile:
1
```

The wizard records:

```
Provider:
user-created

Profile:
us.conf
```

---

# Step 6 - Import Profile

Create:

```
providers/<provider>/<profile>
```

Example:

```
providers/proton/us.conf
```

The original file should remain untouched.

---

# Step 7 - Validate Configuration

Check:

- File exists
- Required WireGuard sections exist
- PrivateKey exists
- Peer exists
- Endpoint exists

Example:

```
✓ Interface section found
✓ Peer section found
✓ Endpoint found
```

---

# Step 8 - Generate Configuration

Create:

```
configs/wireproxy.conf
```

Using:

```
WGConfig = <active profile>
```

and:

```
[Socks5]
BindAddress = 127.0.0.1:25344
```

---

# Step 9 - Final Test

Run validation:

```
twp doctor
```

Expected:

```
STATUS: READY
```

---

# Completion Message

Example:

```
Setup complete!

Provider:
proton

Profile:
us.conf

Run:

twp start
```

---

# Security Considerations

`twp init` must:

- never display private keys
- never upload configuration files
- never modify original WireGuard files
- warn users before deleting profiles
- protect permissions on imported files

---

# Future Improvements

Possible additions:

```
twp init --import /path/file.conf
twp init --provider proton
twp init --non-interactive
```

These support automation and advanced users while keeping the beginner workflow simple.
