{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.3?dir=dev;
  };

  outputs = inputs: inputs.dev.main {
    inherit inputs;

    config = rec {
      slug = "kustomize";
      version = "4.5.7";
      homepage = "https://github.com/defn/pkg/tree/master/${slug}";
      description = "${slug}";

      url_template = input: "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${input.version}/kustomize_v${input.version}_${input.os}_${input.arch}.tar.gz";

      installPhase = { src }: ''
        install -m 0755 -d $out $out/bin
        install -m 0755 kustomize $out/bin/kustomize
      '';

      downloads = {
        "x86_64-linux" = rec {
          inherit version;
          os = "linux";
          arch = "amd64";
          sha256 = "sha256-cB48S/oU5MUg1IH99xMfkCUxv8ACy1Bi3PMSY6CccMk";
        };
        "aarch64-linux" = rec {
          inherit version;
          os = "linux";
          arch = "arm64";
          sha256 = "sha256-ZWZbOSl8xzwTkY8Fu+hFDRdVbwrNFiQqM5Jx4Uhh32c";
        };
        "x86_64-darwin" = rec {
          inherit version;
          os = "darwin";
          arch = "amd64";
          sha256 = "sha256-b9V+eO0MBrW92CdQxdxtD5kqe5JtEU/pS+Rten4ytjo";
        };
        "aarch64-darwin" = rec {
          inherit version;
          os = "darwin";
          arch = "arm64";
          sha256 = "sha256-PB6Llc70/25S1fS4xluNnQa3X0LRy0CYbB1ncp2CQRo";
        };
      };
    };

    handler = { pkgs, wrap, system }: rec {
      devShell = wrap.devShell;
      defaultPackage = wrap.downloadBuilder { };
    };
  };
}
