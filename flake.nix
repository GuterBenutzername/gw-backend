{
  description = "gw-backend development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          go
          gotools
          golangci-lint
	  postgresql
        ];
      shellHook = let cleanUp = shell_commands:
        ''
	export LANG=en_US.UTF-8 
           export PGDATABASE=gw 
           export PGDATA="$PWD/pg/pgdata" 
           export PGHOST="$PWD/pg/sockets" 
           export PGPORT="5433" 
           export PGUSER="$USER"
	   export logfile="$PWD/pg/logs" 
          trap \
          "
          ${ builtins.concatStringsSep "" shell_commands }
          " \
          EXIT
	  ./postgres_init.sh add
        ''; in 
     		cleanUp [
      ''
        echo -n "shutting down postgres..."
      ''
      ( builtins.readFile ./postgres_stop.sh )
      ''
        echo "done."
      ''
];
      };
    });
  };
}
