{ lib, pkgs }:

let
  inherit (lib) getExe;

  # PIA CA certificate for API authentication
  caCert = pkgs.writeText "ca.rsa.4096.crt" ''
    -----BEGIN CERTIFICATE-----
    MIIHqzCCBZOgAwIBAgIJAJ0u+vODZJntMA0GCSqGSIb3DQEBDQUAMIHoMQswCQYD
    VQQGEwJVUzELMAkGA1UECBMCQ0ExEzARBgNVBAcTCkxvc0FuZ2VsZXMxIDAeBgNV
    BAoTF1ByaXZhdGUgSW50ZXJuZXQgQWNjZXNzMSAwHgYDVQQLExdQcml2YXRlIElu
    dGVybmV0IEFjY2VzczEgMB4GA1UEAxMXUHJpdmF0ZSBJbnRlcm5ldCBBY2Nlc3Mx
    IDAeBgNVBCkTF1ByaXZhdGUgSW50ZXJuZXQgQWNjZXNzMS8wLQYJKoZIhvcNAQkB
    FiBzZWN1cmVAcHJpdmF0ZWludGVybmV0YWNjZXNzLmNvbTAeFw0xNDA0MTcxNzQw
    MzNaFw0zNDA0MTIxNzQwMzNaMIHoMQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0Ex
    EzARBgNVBAcTCkxvc0FuZ2VsZXMxIDAeBgNVBAoTF1ByaXZhdGUgSW50ZXJuZXQg
    QWNjZXNzMSAwHgYDVQQLExdQcml2YXRlIEludGVybmV0IEFjY2VzczEgMB4GA1UE
    AxMXUHJpdmF0ZSBJbnRlcm5ldCBBY2Nlc3MxIDAeBgNVBCkTF1ByaXZhdGUgSW50
    ZXJuZXQgQWNjZXNzMS8wLQYJKoZIhvcNAQkBFiBzZWN1cmVAcHJpdmF0ZWludGVy
    bmV0YWNjZXNzLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALVk
    hjumaqBbL8aSgj6xbX1QPTfTd1qHsAZd2B97m8Vw31c/2yQgZNf5qZY0+jOIHULN
    De4R9TIvyBEbvnAg/OkPw8n/+ScgYOeH876VUXzjLDBnDb8DLr/+w9oVsuDeFJ9K
    V2UFM1OYX0SnkHnrYAN2QLF98ESK4NCSU01h5zkcgmQ+qKSfA9Ny0/UpsKPBFqsQ
    25NvjDWFhCpeqCHKUJ4Be27CDbSl7lAkBuHMPHJs8f8xPgAbHRXZOxVCpayZ2SND
    fCwsnGWpWFoMGvdMbygngCn6jA/W1VSFOlRlfLuuGe7QFfDwA0jaLCxuWt/BgZyl
    p7tAzYKR8lnWmtUCPm4+BtjyVDYtDCiGBD9Z4P13RFWvJHw5aapx/5W/CuvVyI7p
    Kwvc2IT+KPxCUhH1XI8ca5RN3C9NoPJJf6qpg4g0rJH3aaWkoMRrYvQ+5PXXYUzj
    tRHImghRGd/ydERYoAZXuGSbPkm9Y/p2X8unLcW+F0xpJD98+ZI+tzSsI99Zs5wi
    jSUGYr9/j18KHFTMQ8n+1jauc5bCCegN27dPeKXNSZ5riXFL2XX6BkY68y58UaNz
    meGMiUL9BOV1iV+PMb7B7PYs7oFLjAhh0EdyvfHkrh/ZV9BEhtFa7yXp8XR0J6vz
    1YV9R6DYJmLjOEbhU8N0gc3tZm4Qz39lIIG6w3FDAgMBAAGjggFUMIIBUDAdBgNV
    HQ4EFgQUrsRtyWJftjpdRM0+925Y6Cl08SUwggEfBgNVHSMEggEWMIIBEoAUrsRt
    yWJftjpdRM0+925Y6Cl08SWhge6kgeswgegxCzAJBgNVBAYTAlVTMQswCQYDVQQI
    EwJDQTETMBEGA1UEBxMKTG9zQW5nZWxlczEgMB4GA1UEChMXUHJpdmF0ZSBJbnRl
    cm5ldCBBY2Nlc3MxIDAeBgNVBAsTF1ByaXZhdGUgSW50ZXJuZXQgQWNjZXNzMSAw
    HgYDVQQDExdQcml2YXRlIEludGVybmV0IEFjY2VzczEgMB4GA1UEKRMXUHJpdmF0
    ZSBJbnRlcm5ldCBBY2Nlc3MxLzAtBgkqhkiG9w0BCQEWIHNlY3VyZUBwcml2YXRl
    aW50ZXJuZXRhY2Nlc3MuY29tggkAnS7684Nkme0wDAYDVR0TBAUwAwEB/zANBgkq
    hkiG9w0BAQ0FAAOCAgEAJsfhsPk3r8kLXLxY+v+vHzbr4ufNtqnL9/1Uuf8NrsCt
    pXAoyZ0YqfbkWx3NHTZ7OE9ZRhdMP/RqHQE1p4N4Sa1nZKhTKasV6KhHDqSCt/dv
    Em89xWm2MVA7nyzQxVlHa9AkcBaemcXEiyT19XdpiXOP4Vhs+J1R5m8zQOxZlV1G
    tF9vsXmJqWZpOVPmZ8f35BCsYPvv4yMewnrtAC8PFEK/bOPeYcKN50bol22QYaZu
    LfpkHfNiFTnfMh8sl/ablPyNY7DUNiP5DRcMdIwmfGQxR5WEQoHL3yPJ42LkB5zs
    6jIm26DGNXfwura/mi105+ENH1CaROtRYwkiHb08U6qLXXJz80mWJkT90nr8Asj3
    5xN2cUppg74nG3YVav/38P48T56hG1NHbYF5uOCske19F6wi9maUoto/3vEr0rnX
    JUp2KODmKdvBI7co245lHBABWikk8VfejQSlCtDBXn644ZMtAdoxKNfR2WTFVEwJ
    iyd1Fzx0yujuiXDROLhISLQDRjVVAvawrAtLZWYK31bY7KlezPlQnl/D9Asxe85l
    8jO5+0LdJ6VyOs/Hd4w52alDW/MFySDZSfQHMTIc30hLBJ8OnCEIvluVQQ2UQvoW
    +no177N9L2Y+M9TcTA62ZyMXShHQGeh20rb4kK8f+iFX8NxtdHVSkxMEFSfDDyQ=
    -----END CERTIFICATE-----
  '';

  # OpenVPN standard configuration template
  ovpnStandard = pkgs.writeText "standard.ovpn" ''
    client
    dev tun06
    resolv-retry infinite
    nobind
    persist-key
    persist-tun
    cipher aes-128-cbc
    auth sha1
    tls-client
    remote-cert-tls server
    auth-user-pass /opt/piavpn-manual/credentials
    compress
    verb 1
    reneg-sec 0
    <crt>
    ${builtins.readFile caCert}
    </crt>
    disable-occ
    script-security 2
    up /opt/piavpn-manual/openvpn_up.sh
    down /opt/piavpn-manual/openvpn_down.sh
  '';

  # OpenVPN strong encryption configuration template  
  ovpnStrong = pkgs.writeText "strong.ovpn" ''
    client
    dev tun06
    resolv-retry infinite
    nobind
    persist-key
    persist-tun
    cipher aes-256-cbc
    auth sha256
    tls-client
    remote-cert-tls server
    auth-user-pass /opt/piavpn-manual/credentials
    compress
    verb 1
    reneg-sec 0
    <crt>
    ${builtins.readFile caCert}
    </crt>
    disable-occ
    script-security 2
    up /opt/piavpn-manual/openvpn_up.sh
    down /opt/piavpn-manual/openvpn_down.sh
  '';

  runtimeDeps = with pkgs; [
    coreutils
    curl
    jq
    wireguard-tools
    openvpn
    fzf
    gnugrep
    gnused
    gawk
    iproute2
    procps
    findutils
  ];

in
pkgs.writeShellScriptBin "pia" ''
  set -euo pipefail
  export PATH="${lib.makeBinPath runtimeDeps}:$PATH"

  # Configuration paths
  PIA_DIR="/opt/piavpn-manual"
  CA_CERT="${caCert}"
  OVPN_STANDARD="${ovpnStandard}"
  OVPN_STRONG="${ovpnStrong}"
  SERVERLIST_URL="https://serverlist.piaservers.net/vpninfo/servers/v6"

  # Colors for output
  if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
  else
    RED="" GREEN="" YELLOW="" BLUE="" NC=""
  fi

  usage() {
    echo "Usage: pia <command> [options]"
    echo ""
    echo "Commands:"
    echo "  list                  List all available VPN regions"
    echo "  search                Interactive region search with fzf"
    echo "  connect <region>      Connect to a VPN region"
    echo "  disconnect            Disconnect from VPN"
    echo "  status                Show current VPN connection status"
    echo "  token                 Get authentication token"
    echo ""
    echo "Options:"
    echo "  --protocol <wg|ovpn>  VPN protocol (default: wg)"
    echo "  --port-forward        Enable port forwarding"
    echo "  --dns                 Use PIA DNS servers"
    echo ""
    echo "Environment variables:"
    echo "  PIA_USER              PIA username (p#######)"
    echo "  PIA_PASS              PIA password"
    echo "  PIA_TOKEN             Authentication token (if already obtained)"
    echo ""
    echo "Examples:"
    echo "  pia list"
    echo "  pia connect japan --protocol wg"
    echo "  pia connect us-east --protocol ovpn --port-forward"
    echo "  pia disconnect"
  }

  ensure_root() {
    if [[ $EUID -ne 0 ]]; then
      if command -v doas &>/dev/null; then
        exec doas "$0" "$@"
      elif command -v sudo &>/dev/null; then
        exec sudo "$0" "$@"
      else
        echo -e "''${RED}This command requires root privileges.''${NC}"
        exit 1
      fi
    fi
  }

  ensure_credentials() {
    if [[ -z "''${PIA_USER:-}" ]] || [[ -z "''${PIA_PASS:-}" ]]; then
      if [[ -z "''${PIA_TOKEN:-}" ]]; then
        echo -e "''${RED}Error: PIA_USER and PIA_PASS environment variables required.''${NC}"
        echo "Or provide PIA_TOKEN if you already have an authentication token."
        exit 1
      fi
    fi
  }

  get_token() {
    if [[ -n "''${PIA_TOKEN:-}" ]]; then
      echo "$PIA_TOKEN"
      return
    fi

    echo -e "''${BLUE}Getting authentication token...''${NC}"
    local response
    response=$(curl -s --location --request POST \
      'https://www.privateinternetaccess.com/api/client/v2/token' \
      --form "username=$PIA_USER" \
      --form "password=$PIA_PASS")

    local token
    token=$(echo "$response" | jq -r '.token // empty')
    
    if [[ -z "$token" ]]; then
      echo -e "''${RED}Failed to authenticate. Check your credentials.''${NC}"
      exit 1
    fi
    
    echo -e "''${GREEN}Authentication successful!''${NC}"
    echo "$token"
  }

  get_regions() {
    curl -s "$SERVERLIST_URL" | head -1
  }

  list_regions() {
    echo -e "''${BLUE}Fetching server list...''${NC}"
    local regions
    regions=$(get_regions)
    
    if [[ ''${#regions} -lt 1000 ]]; then
      echo -e "''${RED}Failed to fetch server list.''${NC}"
      exit 1
    fi

    echo ""
    # Print table header
    printf "''${GREEN}%-25s %-40s %s''${NC}\n" "REGION ID" "NAME" "PORT FORWARD"
    printf "%-25s %-40s %s\n" "-------------------------" "----------------------------------------" "------------"
    
    # Print sorted regions
    echo "$regions" | jq -r '.regions | sort_by(.id)[] | "\(.id)\t\(.name)\t\(.port_forward)"' | \
      while IFS=$'\t' read -r id name pf; do
        if [[ "$pf" == "true" ]]; then
          pf_display="''${GREEN}Yes''${NC}"
        else
          pf_display="''${RED}No''${NC}"
        fi
        printf "%-25s %-40s %b\n" "$id" "$name" "$pf_display"
      done
  }

  search_regions() {
    local regions
    regions=$(get_regions)
    
    # Format as table for fzf, using tab separator for clean columns
    local header="REGION ID\tNAME\tPORT FORWARD"
    local table
    table=$(echo "$regions" | jq -r '.regions | sort_by(.id)[] | "\(.id)\t\(.name)\t\(if .port_forward then "Yes" else "No" end)"')
    
    # Use fzf with header and column alignment
    selected=$(printf "%s\n%s" "$header" "$table" | \
      column -t -s $'\t' | \
      fzf --header-lines=1 --prompt="Select region: " --ansi)
    
    # Extract region ID (first column)
    echo "$selected" | awk '{print $1}'
  }

  connect_wireguard() {
    local region_id="$1"
    local port_forward="''${2:-false}"
    local use_dns="''${3:-true}"

    echo -e "''${BLUE}Connecting to $region_id via WireGuard...''${NC}"

    local regions
    regions=$(get_regions)
    
    local region_data
    region_data=$(echo "$regions" | jq -r --arg id "$region_id" '.regions[] | select(.id==$id)')
    
    if [[ -z "$region_data" ]]; then
      echo -e "''${RED}Invalid region: $region_id''${NC}"
      exit 1
    fi

    local server_ip server_hostname
    server_ip=$(echo "$region_data" | jq -r '.servers.wg[0].ip')
    server_hostname=$(echo "$region_data" | jq -r '.servers.wg[0].cn')

    local token
    token=$(get_token)

    # Generate WireGuard keys
    local priv_key pub_key
    priv_key=$(wg genkey)
    pub_key=$(echo "$priv_key" | wg pubkey)

    echo -e "''${BLUE}Registering public key with PIA...''${NC}"
    local wg_response
    wg_response=$(curl -s -G \
      --connect-to "$server_hostname::$server_ip:" \
      --cacert "$CA_CERT" \
      --data-urlencode "pt=$token" \
      --data-urlencode "pubkey=$pub_key" \
      "https://$server_hostname:1337/addKey")

    if [[ $(echo "$wg_response" | jq -r '.status') != "OK" ]]; then
      echo -e "''${RED}Failed to register with WireGuard server.''${NC}"
      echo "$wg_response"
      exit 1
    fi

    # Disconnect existing connection
    wg-quick down pia 2>/dev/null || true

    # Create WireGuard config
    mkdir -p /etc/wireguard
    local dns_config=""
    if [[ "$use_dns" == "true" ]]; then
      local dns_server
      dns_server=$(echo "$wg_response" | jq -r '.dns_servers[0]')
      dns_config="DNS = $dns_server"
    fi

    cat > /etc/wireguard/pia.conf <<EOF
[Interface]
Address = $(echo "$wg_response" | jq -r '.peer_ip')
PrivateKey = $priv_key
$dns_config

[Peer]
PersistentKeepalive = 25
PublicKey = $(echo "$wg_response" | jq -r '.server_key')
AllowedIPs = 0.0.0.0/0
Endpoint = $server_ip:$(echo "$wg_response" | jq -r '.server_port')
EOF

    chmod 600 /etc/wireguard/pia.conf

    echo -e "''${BLUE}Starting WireGuard interface...''${NC}"
    wg-quick up pia

    echo ""
    echo -e "''${GREEN}Connected to $region_id via WireGuard!''${NC}"
    echo ""
    echo "To disconnect: pia disconnect"

    if [[ "$port_forward" == "true" ]]; then
      echo ""
      echo -e "''${YELLOW}Port forwarding requested. Starting port forwarding...''${NC}"
      setup_port_forwarding "$server_ip" "$server_hostname" "$token"
    fi
  }

  connect_openvpn() {
    local region_id="$1"
    local port_forward="''${2:-false}"
    local use_dns="''${3:-true}"
    local protocol="''${4:-udp}"
    local encryption="''${5:-standard}"

    echo -e "''${BLUE}Connecting to $region_id via OpenVPN ($protocol/$encryption)...''${NC}"

    local regions
    regions=$(get_regions)
    
    local region_data
    region_data=$(echo "$regions" | jq -r --arg id "$region_id" '.regions[] | select(.id==$id)')
    
    if [[ -z "$region_data" ]]; then
      echo -e "''${RED}Invalid region: $region_id''${NC}"
      exit 1
    fi

    local server_ip server_hostname
    if [[ "$protocol" == "tcp" ]]; then
      server_ip=$(echo "$region_data" | jq -r '.servers.ovpntcp[0].ip')
      server_hostname=$(echo "$region_data" | jq -r '.servers.ovpntcp[0].cn')
    else
      server_ip=$(echo "$region_data" | jq -r '.servers.ovpnudp[0].ip')
      server_hostname=$(echo "$region_data" | jq -r '.servers.ovpnudp[0].cn')
    fi

    local token
    token=$(get_token)

    # Determine port
    local port
    if [[ "$protocol" == "udp" ]]; then
      if [[ "$encryption" == "standard" ]]; then port=1198; else port=1197; fi
    else
      if [[ "$encryption" == "standard" ]]; then port=502; else port=501; fi
    fi

    # Setup directories and credentials
    mkdir -p "$PIA_DIR"
    echo "''${token:0:62}
''${token:62}" > "$PIA_DIR/credentials"
    chmod 600 "$PIA_DIR/credentials"

    # Create up/down scripts
    if [[ "$use_dns" == "true" ]]; then
      cat > "$PIA_DIR/openvpn_up.sh" <<'UPSCRIPT'
#!/bin/bash
printf '%s\n' "nameserver $DNS_1" > /etc/resolv.conf
echo "$route_vpn_gateway" > /opt/piavpn-manual/route_info
UPSCRIPT
      cat > "$PIA_DIR/openvpn_down.sh" <<'DOWNSCRIPT'
#!/bin/bash
# Restore DNS settings here if needed
DOWNSCRIPT
    else
      cat > "$PIA_DIR/openvpn_up.sh" <<'UPSCRIPT'
#!/bin/bash
echo "$route_vpn_gateway" > /opt/piavpn-manual/route_info
UPSCRIPT
      cat > "$PIA_DIR/openvpn_down.sh" <<'DOWNSCRIPT'
#!/bin/bash
DOWNSCRIPT
    fi
    chmod +x "$PIA_DIR/openvpn_up.sh" "$PIA_DIR/openvpn_down.sh"

    # Create OpenVPN config
    local ovpn_template
    if [[ "$encryption" == "strong" ]]; then
      ovpn_template="$OVPN_STRONG"
    else
      ovpn_template="$OVPN_STANDARD"
    fi
    
    cat "$ovpn_template" > "$PIA_DIR/pia.ovpn"
    echo "remote $server_ip $port $protocol" >> "$PIA_DIR/pia.ovpn"

    # Kill existing OpenVPN if running
    if [[ -f "$PIA_DIR/pia_pid" ]]; then
      local old_pid
      old_pid=$(cat "$PIA_DIR/pia_pid" 2>/dev/null || echo "")
      if [[ -n "$old_pid" ]] && kill -0 "$old_pid" 2>/dev/null; then
        echo -e "''${YELLOW}Stopping existing OpenVPN connection...''${NC}"
        kill "$old_pid" 2>/dev/null || true
        sleep 2
      fi
    fi

    echo -e "''${BLUE}Starting OpenVPN...''${NC}"
    openvpn --daemon \
      --config "$PIA_DIR/pia.ovpn" \
      --writepid "$PIA_DIR/pia_pid" \
      --log "$PIA_DIR/debug_info"

    # Wait for connection
    local connected=false
    for i in {1..10}; do
      sleep 1
      if grep -q "Initialization Sequence Complete" "$PIA_DIR/debug_info" 2>/dev/null; then
        connected=true
        break
      fi
    done

    if [[ "$connected" != "true" ]]; then
      echo -e "''${RED}Failed to establish OpenVPN connection within 10 seconds.''${NC}"
      cat "$PIA_DIR/debug_info" 2>/dev/null || true
      exit 1
    fi

    local ovpn_pid gateway_ip
    ovpn_pid=$(cat "$PIA_DIR/pia_pid")
    gateway_ip=$(cat "$PIA_DIR/route_info" 2>/dev/null || echo "unknown")

    echo ""
    echo -e "''${GREEN}Connected to $region_id via OpenVPN!''${NC}"
    echo "PID: $ovpn_pid"
    echo "Gateway: $gateway_ip"
    echo ""
    echo "To disconnect: pia disconnect"

    if [[ "$port_forward" == "true" ]]; then
      echo ""
      echo -e "''${YELLOW}Port forwarding requested. Starting port forwarding...''${NC}"
      setup_port_forwarding "$gateway_ip" "$server_hostname" "$token"
    fi
  }

  setup_port_forwarding() {
    local gateway="$1"
    local hostname="$2"
    local token="$3"

    local pf_response
    pf_response=$(curl -s -G \
      --connect-to "$hostname::$gateway:" \
      --cacert "$CA_CERT" \
      --data-urlencode "token=$token" \
      "https://$hostname:19999/getSignature")

    local status
    status=$(echo "$pf_response" | jq -r '.status')
    
    if [[ "$status" != "OK" ]]; then
      echo -e "''${RED}Failed to get port forwarding signature.''${NC}"
      echo "$pf_response"
      return 1
    fi

    local payload signature port
    payload=$(echo "$pf_response" | jq -r '.payload')
    signature=$(echo "$pf_response" | jq -r '.signature')
    port=$(echo "$payload" | base64 -d | jq -r '.port')

    echo -e "''${GREEN}Port forwarding enabled!''${NC}"
    echo -e "Forwarded port: ''${GREEN}$port''${NC}"
    echo ""
    echo "Note: You must call bindPort every 15 minutes to keep the port."
    echo "Payload: $payload"
    echo "Signature: $signature"

    # Bind the port
    local bind_response
    bind_response=$(curl -sG \
      --connect-to "$hostname::$gateway:" \
      --cacert "$CA_CERT" \
      --data-urlencode "payload=$payload" \
      --data-urlencode "signature=$signature" \
      "https://$hostname:19999/bindPort")

    echo "Bind response: $(echo "$bind_response" | jq -r '.message')"
  }

  disconnect() {
    echo -e "''${BLUE}Disconnecting VPN...''${NC}"
    
    # Try WireGuard
    if wg-quick down pia 2>/dev/null; then
      echo -e "''${GREEN}WireGuard disconnected.''${NC}"
    fi

    # Try OpenVPN
    if [[ -f "$PIA_DIR/pia_pid" ]]; then
      local pid
      pid=$(cat "$PIA_DIR/pia_pid" 2>/dev/null || echo "")
      if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid"
        echo -e "''${GREEN}OpenVPN disconnected (PID: $pid).''${NC}"
      fi
      rm -f "$PIA_DIR/pia_pid"
    fi

    echo -e "''${GREEN}Disconnected.''${NC}"
  }

  show_status() {
    echo -e "''${BLUE}VPN Status:''${NC}"
    echo ""
    
    # Check WireGuard
    if ip link show pia &>/dev/null; then
      echo -e "''${GREEN}WireGuard (pia): Connected''${NC}"
      wg show pia 2>/dev/null || true
    else
      echo "WireGuard (pia): Not connected"
    fi
    
    echo ""
    
    # Check OpenVPN
    if [[ -f "$PIA_DIR/pia_pid" ]]; then
      local pid
      pid=$(cat "$PIA_DIR/pia_pid" 2>/dev/null || echo "")
      if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
        echo -e "''${GREEN}OpenVPN (PID $pid): Connected''${NC}"
        local gateway
        gateway=$(cat "$PIA_DIR/route_info" 2>/dev/null || echo "unknown")
        echo "Gateway: $gateway"
      else
        echo "OpenVPN: Not connected"
      fi
    else
      echo "OpenVPN: Not connected"
    fi
  }

  # Save original arguments for root re-execution
  ORIG_ARGS=("$@")

  # Parse command line
  COMMAND="''${1:-}"
  shift || true

  PROTOCOL="wg"
  PORT_FORWARD="false"
  USE_DNS="true"
  REGION=""
  OVPN_PROTOCOL="udp"
  ENCRYPTION="standard"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --protocol)
        PROTOCOL="$2"
        shift 2
        ;;
      --port-forward)
        PORT_FORWARD="true"
        shift
        ;;
      --dns)
        USE_DNS="true"
        shift
        ;;
      --no-dns)
        USE_DNS="false"
        shift
        ;;
      --tcp)
        OVPN_PROTOCOL="tcp"
        shift
        ;;
      --strong)
        ENCRYPTION="strong"
        shift
        ;;
      *)
        if [[ -z "$REGION" ]]; then
          REGION="$1"
        fi
        shift
        ;;
    esac
  done

  case "$COMMAND" in
    list)
      list_regions
      ;;
    search)
      search_regions
      ;;
    connect)
      ensure_root "''${ORIG_ARGS[@]}"
      ensure_credentials
      
      if [[ -z "$REGION" ]]; then
        REGION=$(search_regions)
      fi
      
      if [[ -z "$REGION" ]]; then
        echo -e "''${RED}No region specified.''${NC}"
        exit 1
      fi
      
      if [[ "$PROTOCOL" == "wg" ]] || [[ "$PROTOCOL" == "wireguard" ]]; then
        connect_wireguard "$REGION" "$PORT_FORWARD" "$USE_DNS"
      else
        connect_openvpn "$REGION" "$PORT_FORWARD" "$USE_DNS" "$OVPN_PROTOCOL" "$ENCRYPTION"
      fi
      ;;
    disconnect)
      ensure_root "''${ORIG_ARGS[@]}"
      disconnect
      ;;
    status)
      show_status
      ;;
    token)
      ensure_credentials
      get_token
      ;;
    help|--help|-h)
      usage
      ;;
    *)
      usage
      exit 1
      ;;
  esac
''
