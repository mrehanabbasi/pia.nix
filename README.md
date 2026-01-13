# pia.nix

Private Internet Access VPN CLI for NixOS using the official [manual-connections](https://github.com/pia-foss/manual-connections) API.

Supports both **WireGuard** and **OpenVPN** protocols with region selection and port forwarding.

## Features

- Connect via WireGuard or OpenVPN
- Dynamic server list from PIA API (sorted alphabetically)
- Interactive region selection with fzf
- Port forwarding support
- PIA DNS integration
- NixOS module for declarative configuration
- Auto-connect on boot
- Secrets management support (sops-nix, agenix)

## Installation

### Flake-based Installation

Add to your flake inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pia.url = "github:yourusername/pia.nix";
    pia.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, pia, ... }: {
    nixosConfigurations.yourHost = nixpkgs.lib.nixosSystem {
      modules = [
        pia.nixosModules.default
        # your other modules
      ];
    };
  };
}
```

## NixOS Module Configuration

### Basic Configuration (Not Recommended for Production)

```nix
{ config, ... }: {
  services.pia = {
    enable = true;
    
    # WARNING: Credentials stored in Nix store - use credentialsFile instead!
    credentials = {
      username = "p1234567";
      password = "yourpassword";
    };
    
    protocol = "wireguard";
    
    autoConnect = {
      enable = true;
      region = "japan";
    };
  };
}
```

### With sops-nix (Recommended)

First, create a sops secret file with your PIA credentials:

```yaml
# secrets/pia.yaml
pia: |
  p1234567
  yourpassword
```

Then configure sops-nix and pia.nix:

```nix
{ config, ... }: {
  # sops-nix configuration
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    
    secrets.pia = {
      # The secret will be available at /run/secrets/pia
      mode = "0400";
    };
  };

  services.pia = {
    enable = true;
    
    # Use the sops secret file
    credentials.credentialsFile = config.sops.secrets.pia.path;
    
    protocol = "wireguard";
    
    autoConnect = {
      enable = true;
      region = "japan";
    };
    
    # Optional settings
    portForwarding.enable = true;
    dns.enable = true;
  };
}
```

### With agenix

Create an age-encrypted secret:

```bash
# Create secret file with credentials (two lines: username, password)
echo -e "p1234567\nyourpassword" > /tmp/pia.txt
agenix -e secrets/pia.age < /tmp/pia.txt
rm /tmp/pia.txt
```

Then configure:

```nix
{ config, ... }: {
  age.secrets.pia = {
    file = ./secrets/pia.age;
    mode = "0400";
  };

  services.pia = {
    enable = true;
    credentials.credentialsFile = config.age.secrets.pia.path;
    
    protocol = "wireguard";
    autoConnect = {
      enable = true;
      region = "nl_amsterdam";
    };
  };
}
```

### Full Configuration Reference

```nix
{ config, ... }: {
  services.pia = {
    enable = true;
    
    # Credentials - use ONE of these methods:
    credentials = {
      # Method 1: Inline (NOT recommended - stored in Nix store)
      username = "p1234567";
      password = "yourpassword";
      
      # Method 2: File (recommended with sops-nix/agenix)
      # File format: line 1 = username, line 2 = password
      credentialsFile = config.sops.secrets.pia.path;
    };
    
    # VPN protocol: "wireguard" (default) or "openvpn"
    protocol = "wireguard";
    
    # Auto-connect on boot
    autoConnect = {
      enable = true;
      region = "japan";  # Run `pia list` to see all regions
    };
    
    # Port forwarding (not available in US regions)
    portForwarding.enable = true;
    
    # Use PIA's DNS servers
    dns.enable = true;
    
    # OpenVPN-specific settings (only used when protocol = "openvpn")
    openvpn = {
      protocol = "udp";      # "udp" or "tcp"
      encryption = "standard"; # "standard" or "strong"
    };
  };
}
```

## CLI Usage

```bash
# Set credentials (for CLI usage without NixOS module)
export PIA_USER="p1234567"
export PIA_PASS="yourpassword"

# List available regions (sorted alphabetically)
pia list

# Interactive region search with fzf
pia search

# Connect to a region via WireGuard (default)
pia connect japan

# Connect via OpenVPN with port forwarding
pia connect us_east --protocol ovpn --port-forward

# Connect with specific OpenVPN options
pia connect uk --protocol ovpn --tcp --strong

# Check connection status
pia status

# Disconnect
pia disconnect

# Get authentication token (useful for debugging)
pia token
```

## Available Regions

Run `pia list` to see all available regions sorted alphabetically. Common regions include:

| Region ID | Location | Port Forwarding |
|-----------|----------|-----------------|
| `au_sydney` | AU Sydney | Yes |
| `ca` | CA Montreal | Yes |
| `de_berlin` | DE Berlin | Yes |
| `japan` | Japan | Yes |
| `nl_amsterdam` | Netherlands | Yes |
| `sg` | Singapore | Yes |
| `uk` | UK London | Yes |
| `us_east` | US East | No |
| `us_west` | US West | No |

## Port Forwarding

Port forwarding is available in most regions (check the `PF` column in `pia list`).
When enabled, PIA assigns you a forwarded port that you can use for services like
torrents, game servers, or other applications that need incoming connections.

**Note:** Port forwarding is **not available** in US regions due to legal requirements.

To keep the port active, PIA requires periodic "keepalive" requests. The CLI handles
the initial binding, but for long-running connections you may need to implement
additional keepalive logic.

## Troubleshooting

### Connection Issues

1. **"Permission denied"** - VPN commands require root. The CLI auto-escalates via sudo/doas.

2. **"Failed to fetch server list"** - Check internet connectivity.

3. **WireGuard fails to connect** - Ensure the `wireguard` kernel module is loaded:
   ```bash
   lsmod | grep wireguard
   sudo modprobe wireguard
   ```

4. **Authentication fails** - Verify:
   - Username format is `p#######` (starts with 'p' followed by 7 digits)
   - Password is correct
   - Token hasn't expired (24-hour validity)

### Systemd Service Issues

Check service status and logs:
```bash
systemctl status pia-vpn
journalctl -u pia-vpn -f
```

## Credits

- Based on [pia-foss/manual-connections](https://github.com/pia-foss/manual-connections)
- Inspired by [Fuwn/pia.nix](https://github.com/Fuwn/pia.nix)

## License

MIT
# pia.nix
