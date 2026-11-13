{ inputs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;

    profiles.default = {
      settings = {
        # Аппаратное декодирование видео (VA-API на AMD GPU) и рендеринг
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "gfx.webrender.all" = true;
      };
    };

    policies = let
      mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
        installation_mode = "force_installed";
      });
    in {
      ExtensionSettings = mkExtensionSettings {
        "uBlock0@raymondhill.net" = "ublock-origin";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
        "sponsorBlocker@ajay.app" = "sponsorblock";
        "moz-addon-prod@7tv.app" = "7tv-extension";
      };

      Preferences = {
        "network.http.http3.enable" = {
          Value = false;
          Status = "locked";
        };
      };
    };
  };
}
