# AltDaemon iOS 17 Rootless Fix

A rootless (Dopamine) port of [emp0ry/altdaemon-ios17-roothide-fix](https://github.com/emp0ry/altdaemon-ios17-roothide-fix). It fixes the reproducible **AltDaemon 1.0.1** crash on **iOS 17.0 through 17.3.1** under a rootless jailbreak.

## The problem

On affected devices AltDaemon crashes while accepting a new XPC connection:

```text
EXC_BAD_ACCESS / SIGSEGV
objc_release
XPCConnectionHandler.listener(_:shouldAcceptNewConnection:)
```

## What this package does

This package does **not** include or redistribute AltDaemon. It works with an already installed AltDaemon 1.0.1 executable and:

- Verifies that the expected ARM64 instructions are present
- Replaces two problematic call instructions with `NOP`
- Saves an untouched backup of the original executable
- Re-signs the patched executable with AltDaemon's required entitlements
- Restores the backup when this package is removed, when the backup is available

Original binary backup:

```text
/var/mobile/Library/AltDaemonIOS17RootlessFix/AltDaemon-1.0.1.original
```

## Differences from the RootHide original

- All jailbreak-package paths are remapped under `/var/jb` (rootless layout).
- The RootHide-only `.roothidepatch` dynamic patch-loader symlink has been removed; rootless (Dopamine) does not use it.
- Default targets:
  - Binary: `/var/jb/usr/bin/AltDaemon`
  - Entitlements: `/var/jb/usr/share/altdaemon-ios17-rootless-fix/AltDaemon.entitlements.plist`
  - Launch daemon: `/var/jb/Library/LaunchDaemons/com.rileytestut.altdaemon.plist`

## Requirements

- iOS 17.0 through 17.3.1
- A rootless (Dopamine) environment
- AltDaemon 1.0.1 from the alias20 repository
- `ldid` (provided by the jailbreak)
- `od` and `dd` (install `coreutils` if your environment lacks them)

## Installation

1. Install **AltDaemon 1.0.1** from the alias20 repository (rootless build).
2. Download the latest `.deb` from this repository's Releases page.
3. Install the fix using Sileo, Zebra, Filza, or the command line.
4. Perform a userspace reboot or respring if AltDaemon does not restart automatically.

```sh
sudo dpkg -i ./com.amorcool.altdaemonios17rootlessfix_1.0.1_iphoneos-arm64.deb
```

## Building

```sh
./build.sh          # requires dpkg-deb; outputs build/*.deb
```

On CI this runs automatically on every pushed tag (`v*`) and drafts a release.

## Uninstallation

Remove **AltDaemon iOS 17 Rootless Fix** from Sileo or Zebra. Removing the package automatically restores the original AltDaemon executable from the backup above when available.

## Technical details

The installer patches two ARM64 call sites in the installed AltDaemon executable:

| File offset | Original bytes | Patched bytes |
| --- | --- | --- |
| `0x13DE8` | `0D 67 03 94` | `1F 20 03 D5` |
| `0x13E38` | `F9 66 03 94` | `1F 20 03 D5` |

`1F 20 03 D5` is the ARM64 encoding of a `NOP` instruction.

The installer is intended for the exact AltDaemon 1.0.1 binary described above. It should not blindly patch an unknown or modified executable.

## Disclaimer

This is an unofficial compatibility patch. It is not affiliated with AltStore, AltDaemon, alias20, or Dopamine. Use it at your own risk. No warranty is provided.
