{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.pia;
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    types
    optionalString
    ;
in
{
  options.services.pia = {
    enable = mkEnableOption "Private Internet Access VPN";

    package = mkOption {
      type = types.package;
      default = self.packages.${pkgs.system}.pia;
      defaultText = "self.packages.\${pkgs.system}.pia";
      description = "The PIA CLI package to use.";
    };

    credentials = {
      username = mkOption {
        type = types.str;
        default = "";
        description = ''
          PIA username (p#######).
          Leave empty if using credentialsFile.
          WARNING: This will be stored in the Nix store. Use credentialsFile for secrets.
        '';
      };

      password = mkOption {
        type = types.str;
        default = "";
        description = ''
          PIA password.
          Leave empty if using credentialsFile.
          WARNING: This will be stored in the Nix store. Use credentialsFile for secrets.
        '';
      };

      credentialsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/secrets/pia";
        description = ''
          Path to a file containing PIA credentials.
          The file must contain two lines:
            - Line 1: PIA username (p#######)
            - Line 2: PIA password

          This is the recommended way to provide credentials when using
          secrets managers like sops-nix or agenix.

          Example with sops-nix:
            credentials.credentialsFile = config.sops.secrets.pia.path;

          Example with agenix:
            credentials.credentialsFile = config.age.secrets.pia.path;
        '';
      };
    };

    protocol = mkOption {
      type = types.enum [ "wireguard" "openvpn" ];
      default = "wireguard";
      description = "VPN protocol to use.";
    };

    autoConnect = {
      enable = mkEnableOption "automatic VPN connection on boot";

      region = mkOption {
        type = types.str;
        default = "";
        example = "japan";
        description = ''
          Region ID to connect to (e.g., "us_east", "japan", "uk").
          Run `pia list` to see all available region IDs.
        '';
      };
    };

    portForwarding = {
      enable = mkEnableOption "port forwarding";
    };

    dns = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Use PIA's DNS servers when connected.";
      };
    };

    openvpn = {
      protocol = mkOption {
        type = types.enum [ "udp" "tcp" ];
        default = "udp";
        description = "OpenVPN transport protocol.";
      };

      encryption = mkOption {
        type = types.enum [ "standard" "strong" ];
        default = "standard";
        description = ''
          OpenVPN encryption strength.
          - standard: AES-128-CBC with SHA1
          - strong: AES-256-CBC with SHA256
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Add CLI and required packages to system
    environment.systemPackages = [
      cfg.package
      pkgs.wireguard-tools
      pkgs.openvpn
      pkgs.curl
      pkgs.jq
    ];

    # Required kernel modules for WireGuard
    boot.kernelModules = mkIf (cfg.protocol == "wireguard") [ "wireguard" ];

    # Systemd service for auto-connect
    systemd.services.pia-vpn = mkIf cfg.autoConnect.enable {
      description = "Private Internet Access VPN";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ cfg.package pkgs.coreutils ];

      script =
        let
          protocolArg = if cfg.protocol == "wireguard" then "wg" else "ovpn";
          portForwardArg = optionalString cfg.portForwarding.enable "--port-forward";
          dnsArg = if cfg.dns.enable then "--dns" else "--no-dns";
          tcpArg = optionalString (cfg.openvpn.protocol == "tcp") "--tcp";
          strongArg = optionalString (cfg.openvpn.encryption == "strong") "--strong";

          # Credential setup - either from file or inline
          credSetup =
            if cfg.credentials.credentialsFile != null then ''
              export PIA_USER=$(head -n1 ${cfg.credentials.credentialsFile})
              export PIA_PASS=$(tail -n1 ${cfg.credentials.credentialsFile})
            '' else ''
              export PIA_USER=${lib.escapeShellArg cfg.credentials.username}
              export PIA_PASS=${lib.escapeShellArg cfg.credentials.password}
            '';
        in
        ''
          ${credSetup}
          exec pia connect ${cfg.autoConnect.region} \
            --protocol ${protocolArg} \
            ${portForwardArg} \
            ${dnsArg} \
            ${tcpArg} \
            ${strongArg}
        '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "${cfg.package}/bin/pia disconnect";
      };
    };
  };
}
