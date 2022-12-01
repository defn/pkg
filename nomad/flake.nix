{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.4?dir=dev;
  };

  outputs = inputs: inputs.dev.main {
    inherit inputs;

    config = {
      slug = "nomad";
      version_src = ./VERSION;
      version = builtins.readFile version_src;
      vendor_src = ./VENDOR;
      vendor = builtins.readFile vendor_src;

      url_template = input: "https://releases.hashicorp.com/nomad/${input.version}/nomad_${input.version}_${input.os}_${input.arch}.zip";

      installPhase = { src }: ''
        install -m 0755 -d $out $out/bin
        unzip $src
        install -m 0755 nomad $out/bin/nomad
      '';

      downloads = {
        "x86_64-linux" = {
          version = vendor;
          os = "linux";
          arch = "amd64";
          sha256 = "sha256-FauP0toHHZOFL1m5qIM+OnZJhu+BQMaxH4diE5HmOQI=";
        };
        "aarch64-linux" = {
          version = vendor;
          os = "linux";
          arch = "arm64";
          sha256 = "sha256-IbOvx4vKR4msJxqFXixKmTh20NP4RJlpLQ2dxcir+co=";
        };
        "x86_64-darwin" = {
          version = vendor;
          os = "darwin";
          arch = "amd64";
          sha256 = "sha256-/I11CBNze/UfLVPioWssGKTUZta14xTWVzTbHK1r8gs=";
        };
        "aarch64-darwin" = {
          version = vendor;
          os = "darwin";
          arch = "arm64";
          sha256 = "sha256-TFzVQftil+Yte+iHBx8locdlV44p/eCnhM+n+a56isI=";
        };
      };
    };

    handler = { pkgs, wrap, system }: {
      devShell = wrap.devShell;
      defaultPackage = wrap.downloadBuilder {
        dontUnpack = true;
        buildInputs = [ pkgs.unzip ];
      };
    };
  };
}