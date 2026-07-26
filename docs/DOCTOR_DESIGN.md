# twp doctor Design

## Purpose

The doctor command validates the Termux WireProxy installation and explains problems in beginner-friendly language.

## Goals

- Detect environment
- Check dependencies
- Check project structure
- Check configuration
- Check provider profiles
- Check runtime status
- Provide repair suggestions

## Command

Usage:

twp doctor

Future:

twp doctor --deep


## Checks

### Environment

Verify:

- Running inside Termux
- Required filesystem access
- Supported architecture


### Dependencies

Check:

- wireproxy
- bash
- required Termux commands


### Project Structure

Verify:

- bin/
- scripts/
- configs/
- providers/
- logs/
- state/


### Configuration

Verify:

- project.conf exists
- wireproxy.conf exists
- active provider exists


### Runtime

Verify:

- PID file
- wireproxy process
- SOCKS5 listener


## Output Philosophy

Never only say:

ERROR

Instead:

Problem:
wireproxy is missing.

Fix:
Install with:

pkg install wireproxy
