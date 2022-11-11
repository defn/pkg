{
  inputs = { };

  outputs = inputs: {
    wrap = { other, system, pkgs }:
      let
        inputsList = (pkgs.lib.attrsets.mapAttrsToList (name: value: value) other);
        hasDefaultPackage = (item: acc:
          acc ++
          (
            if item ? ${"defaultPackage"}
            then [ item.defaultPackage.${system} ]
            else [ ]
          ));
      in
      rec {
        devShell = pkgs.mkShell
          rec {
            buildInputs =
              [ other.self.defaultPackage.${system} ]
              ++ pkgs.lib.lists.foldr hasDefaultPackage [ ] inputsList;
          };
      };
  };
}
