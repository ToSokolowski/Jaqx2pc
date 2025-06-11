{
  description = "An app to export Xournal++ (.xopp) files to PDF.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      apps = forEachSupportedSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          
          export-script = pkgs.writeShellApplication {
            name = "jaqx2pc";

            runtimeInputs = with pkgs; [
              bash coreutils findutils xournalpp
            ];

            text = builtins.readFile ./process.sh;
          };
        in
        {
          default = {
            type = "app";
            program = "${export-script}/bin/jaqx2pc";
          };
        });
    };
}