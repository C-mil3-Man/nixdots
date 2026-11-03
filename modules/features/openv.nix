{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.openv = pkgs.writeShellApplication {
        name = "openv";
        runtimeInputs = [
          pkgs.fzf
          pkgs.gawk
          pkgs.gnugrep
        ];
        text = ''
          config=''${OS_CLIENT_CONFIG_FILE:-$HOME/.config/openstack/clouds.yaml}

          [ -f "$config" ] || { echo "openv: $config not found" >&2; exit 1; }

          # List cloud names under the top-level `clouds:` key.
          names() {
            awk '
              /^clouds:/            { in_clouds = 1; next }
              /^[^[:space:]]/       { in_clouds = 0 }
              in_clouds && /^  [A-Za-z0-9_-]+:/ {
                sub(/^  /, ""); sub(/:.*/, ""); print
              }
            ' "$config"
          }

          # Print one cloud's block with secrets filtered out.
          block() {
            awk -v cloud="$1" '
              /^[^[:space:]]/ { grab = 0 }
              /^  [^[:space:]]/ { grab = ($1 == cloud ":") }
              grab && tolower($0) !~ /password|secret|token/
            ' "$config"
          }

          pick() {
            names | fzf --prompt="cloud> " --height=40% --reverse \
              --preview "$0 block {}" --preview-window=right:60%
          }

          usage() {
            cat <<'HLP'
          openv activate [cloud]   print shell code to activate a cloud (fzf if no arg)
          openv deactivate         print shell code to deactivate
          openv who                show active cloud (secrets redacted)
          openv names              list clouds in clouds.yaml
          HLP
          }

          case "''${1:-help}" in
            names) names ;;
            block) block "''${2:?cloud name required}" ;;
            activate)
              cloud=''${2:-$(pick)}
              [ -n "$cloud" ] || exit 1
              names | grep -qxF "$cloud" || { echo "openv: unknown cloud '$cloud'" >&2; exit 1; }
              echo "export OS_CLOUD=$cloud"
              ;;
            deactivate) echo "unset OS_CLOUD" ;;
            who)
              if [ -n "''${OS_CLOUD:-}" ]; then
                echo "cloud: $OS_CLOUD"
                block "$OS_CLOUD"
              else
                echo "openv: no cloud active"
              fi
              ;;
            *) usage ;;
          esac
        '';
      };
    };
}
