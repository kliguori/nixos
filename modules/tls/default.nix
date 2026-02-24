{ config, lib, ... }:
let
  cfg = config.systemOptions.tls;
  impermanenceEnabled = config.systemOptions.impermanence.enable;
in
{
  options.systemOptions.tls.enable = lib.mkEnableOption "Enable ACME TLS (Cloudflare DNS-01)";

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "liguori.km@gmail.com";
        dnsResolver = "1.1.1.1:53";
      };
      certs."liguorihome.com" = {
        domain = "liguorihome.com";
        extraDomainNames = [ "*.liguorihome.com" ];
        dnsProvider = "cloudflare";
        credentialsFile = "/persist/secrets/cloudflare/cloudflare-dns.env";
        group = "acme";
      };
    };

    environment.persistence."/persist".directories = lib.mkIf impermanenceEnabled [
      "/var/lib/acme"
    ];
  };
}
