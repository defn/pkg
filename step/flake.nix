{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.10-rc3?dir=dev;
  };

  outputs = inputs: inputs.dev.main {
    inherit inputs;

    config = rec {
      slug = "step";
      version = builtins.readFile ./VERSION;
      vendor = builtins.readFile ./VENDOR;

      url_template = input: "https://github.com/smallstep/cli/releases/download/v${input.version}/step_${input.os}_${input.version}_${input.arch}.tar.gz";

      installPhase = { src }: ''
        install -m 0755 -d $out $out/bin
        install -m 0755 */bin/step $out/bin/step
      '';

      downloads = {
        "x86_64-linux" = {
          version = vendor;
          os = "linux";
          arch = "amd64";
          sha256 = "sha256-VcdEgQ39k6epscJ2Bq5Vck95af++zhLvWfH55FogUGk="; # x86_64-linux
        };
        "aarch64-linux" = {
          version = vendor;
          os = "linux";
          arch = "arm64";
          sha256 = "sha256-U43WYxVr5/6F4rV7xCmxI5wy3NXgme59WcSHr0ZTbmQ="; # aarch64-linux
        };
        "x86_64-darwin" = {
          version = vendor;
          os = "darwin";
          arch = "amd64";
          sha256 = "sha256-piK/e+kI8LeqROTmhpuP5p0ceoJsQxhdhIn9EPQMkGg="; # x86_64-darwin
        };
        "aarch64-darwin" = {
          version = vendor;
          os = "darwin";
          arch = "arm64";
          sha256 = "sha256-QjeRgRFPkgffFF8h5RPwx/a+/LxXOGnlH5mWmiPYStg="; # aarch64-darwin
        };
      };
    };

    handler = { pkgs, wrap, system }: {
      devShell = wrap.devShell;
      defaultPackage = wrap.downloadBuilder { };
    };
  };
}
