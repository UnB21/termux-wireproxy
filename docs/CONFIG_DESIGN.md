# Configuration Design

## Purpose

Define how Termux WireProxy stores user configuration and generated runtime files.

## Design Principle

Source files and generated files must remain separate.

Tracked by Git:

configs/
- project.conf
- *.example.conf


Generated at runtime:

state/
- wireproxy.conf
- pid files
- runtime information


## Why

Users should be able to run:

twp start
twp stop
twp restart

without creating unnecessary Git changes.

## WireProxy Configuration

The active WireProxy configuration should be generated from:

- active provider
- selected profile
- SOCKS5 settings

The generated file should not be edited manually.

## Security

Never commit:

- WireGuard private keys
- user profiles
- generated runtime paths

## Future

Possible improvements:

- config migration
- backup system
- validation before generation
- encrypted profile storage
