{
  self,
  inputs,
  lib,
  ...
}:
{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    let
      # Pre-generate init scripts at build time for tools that are
      # pure stdout generators (no home-dir/state dependency).
      zoxideInit = pkgs.runCommand "zoxide-init.zsh" { } ''
        ${lib.getExe pkgs.zoxide} init zsh > $out
      '';
      carapaceInit = pkgs.runCommand "carapace-init.zsh" { } ''
        ${lib.getExe pkgs.carapace} _carapace zsh > $out
      '';
      starshipInit = pkgs.runCommand "starship-init.zsh" { } ''
        ${lib.getExe pkgs.starship} init zsh > $out
      '';
      lsColors = pkgs.runCommand "ls-colors.zsh" { } ''
        ${pkgs.coreutils}/bin/dircolors -b > $out
      '';
      # atuin's init reads/creates ~/.config/atuin as a side effect,
      # so it's impure and can't run in the Nix sandbox. Keep it as
      # a runtime eval.

      zshRc = pkgs.writeText "zshrc" ''
        # --- Completion System ---
        autoload -Uz compinit && compinit
        source ${lsColors}
        # Colored, navigable completion menu
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':completion:*' menu select
        # Case-insensitive completion (cd d matches Downloads)
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

        # --- History ---
        HISTFILE="''${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
        HISTSIZE=50000
        SAVEHIST=50000
        mkdir -p "$(dirname "$HISTFILE")"
        setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
        setopt SHARE_HISTORY INC_APPEND_HISTORY

        # --- Shell Options ---
        setopt AUTO_CD
        setopt INTERACTIVE_COMMENTS
        setopt NO_BEEP

        # --- Key Bindings (emacs-style, cursor keys) ---
        bindkey -e
        bindkey "^[[A"   history-search-backward
        bindkey "^[[B"   history-search-forward
        bindkey "^[[H"   beginning-of-line
        bindkey "^[[F"   end-of-line
        bindkey "^[[3~"  delete-char
        # Word movement (Ctrl+Left / Ctrl+Right)
        bindkey "^[[1;5D" backward-word
        bindkey "^[[1;5C" forward-word
        # Word deletion (Ctrl+Backspace / Ctrl+Delete)
        bindkey "^H"      backward-kill-word
        bindkey "^[[3;5~" kill-word

        # --- Custom Functions ---

        # Yazi wrapper: cd into last directory on exit
        function y() {
          local tmp
          tmp=$(mktemp -t "yazi-cwd.XXXXXX")
          command yazi "$@" --cwd-file="$tmp"
          local cwd
          cwd=$(cat -- "$tmp" 2>/dev/null)
          if [[ -n "$cwd" && "$cwd" != "$PWD" && -d "$cwd" ]]; then
            cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }

        # --- Aliases ---
        alias ls="eza --group-directories-first"
        alias cat="bat --style=plain --pager=never"

        # Git
        alias gcmsg="git commit -m"
        alias ga="git add"
        alias gd="git diff"
        alias gp="git push"

        # --- Tool Initializations ---
        source ${zoxideInit}
        source ${carapaceInit}
        source ${starshipInit}
        eval "$(${lib.getExe pkgs.atuin} init zsh)"
        if command -v direnv &>/dev/null; then
          eval "$(direnv hook zsh)"
        fi

        # --- Plugins ---
        # autosuggestions before syntax-highlighting
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        # syntax-highlighting must be sourced last (it wraps ZLE widgets)
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        # Make valid paths visible while typing (default is just underline)
        ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
        ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=cyan,underline'
      '';

      # ZDOTDIR: a directory containing just .zshrc so zsh picks it up
      # without touching the user's home directory at build time.
      zdotdir = pkgs.runCommand "zsh-zdotdir" { } ''
        mkdir -p $out
        cp ${zshRc} $out/.zshrc
      '';
    in
    {
      packages.zsh = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.zsh;
        runtimePkgs = map (p: { data = p; prefix = true; }) [
          pkgs.atuin
          pkgs.zoxide
          pkgs.carapace
          pkgs.starship
          pkgs.bat
        ];
        env = {
          ZDOTDIR = zdotdir;
        };
      };
    };
}
