{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.18?dir=dev;
    c.url = github:defn/pkg/c-0.0.2?dir=c;
  };

  outputs = inputs: inputs.dev.main rec {
    inherit inputs;

    src = builtins.path { path = ./.; name = config.slug; };

    config = rec {
      slug = builtins.readFile ./SLUG;
      version = builtins.readFile ./VERSION;
    };

    handler = { pkgs, wrap, system, builders }: {
      defaultPackage = wrap.bashBuilder {
        inherit src;

        installPhase = ''
          mkdir -p $out/bin
          cp -a $src/bin/n $src/bin/n-* $out/bin/
          chmod 755 $out/bin/*
        '';

        propagatedBuildInputs = [
          inputs.c.defaultPackage.${system}
        ];
      };
    };
  };
}
