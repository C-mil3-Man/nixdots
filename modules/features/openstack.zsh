# OpenStack cloud switcher + CLI shortcuts (openstack-zsh-plugin-inspired)
# Cloud activation is handled by the `openv` package (modules/features/openv.nix);
# these are thin zsh wrappers plus a pile of `openstack ...` aliases.

function openv() {
  eval "$(command openv activate "$@")"
}
function opoff() {
  eval "$(command openv deactivate)"
}
alias opexit=opoff
alias opclear=opoff
alias opwho="command openv who"
alias opstatus="command openv who"
alias opls="command openv names"
alias opclouds="command openv names"

alias op="openstack"

# Compute
alias ops="openstack server list"
alias opsa="openstack server list --all-projects"
alias opss="openstack server show"
alias opsr="openstack server reboot"
alias opsh="openstack server stop"
alias opst="openstack server start"
alias opsdel="openstack server delete"
alias oplog="openstack console log show"

# Networking
alias opnet="openstack network list"
alias opsub="openstack subnet list"
alias oprtr="openstack router list"
alias opfip="openstack floating ip list"
alias opip="openstack floating ip list"
alias opsec="openstack security group list"
alias opsecr="openstack security group rule list"
alias opport="openstack port list"

# Storage & images
alias opvol="openstack volume list"
alias opvola="openstack volume list --all-projects"
alias opsnap="openstack volume snapshot list"
alias opimg="openstack image list"

# Identity
alias opproj="openstack project list"
alias opuser="openstack user list"
alias oprole="openstack role list"
alias optoken="openstack token issue"
alias opfl="openstack flavor list"
alias opkey="openstack keypair list"
alias oplim="openstack limits show --absolute"

# Load balancers
alias oplb="openstack loadbalancer list"

# --- Interactive helpers ---

function opcheck() {
  if [[ -z "$OS_CLOUD" ]]; then
    echo "opcheck: no cloud active (run 'openv' first)" >&2
    return 1
  fi
  local expires
  expires=$(openstack token issue -f value -c expires 2>/dev/null)
  if [[ -n "$expires" ]]; then
    echo "opcheck: ✓ $OS_CLOUD credentials valid (token expires $expires)"
  else
    echo "opcheck: ✗ $OS_CLOUD credentials invalid, expired, or unreachable" >&2
    return 1
  fi
}

function op_prompt_info() {
  [[ -n "$OS_CLOUD" ]] && echo "☁️  $OS_CLOUD"
}

function ops-ssh() {
  local user=ubuntu identity= port= insecure=0
  local -a ssh_opts=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -i|--identity) identity="$2"; shift 2 ;;
      -p|--port)     port="$2";     shift 2 ;;
      --insecure)    insecure=1;    shift   ;;
      *)             user="$1";     shift   ;;
    esac
  done

  local vm
  vm=$(openstack server list -f value -c Name | fzf --prompt="server> ")
  [[ -n "$vm" ]] || return 1

  local ip
  ip=$(openstack server show "$vm" -f value -c addresses \
    | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | tail -1)
  if [[ -z "$ip" ]]; then
    echo "ops-ssh: no IP address found for $vm" >&2
    return 1
  fi

  [[ -n "$identity" ]] && ssh_opts+=(-i "$identity")
  [[ -n "$port"     ]] && ssh_opts+=(-p "$port")
  [[ $insecure -eq 1 ]] && ssh_opts+=(-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null)

  echo "ops-ssh: connecting to $vm ($ip) as $user"
  ssh "${ssh_opts[@]}" "$user@$ip"
}

function ops-console() {
  local vm
  vm=$(openstack server list -f value -c Name | fzf --prompt="server> ")
  [[ -n "$vm" ]] || return 1

  local url
  url=$(openstack console url show --novnc "$vm" -f value -c url 2>/dev/null)
  if [[ -z "$url" ]]; then
    echo "ops-console: could not get a console URL for $vm (tried --novnc)" >&2
    return 1
  fi

  echo "ops-console: opening $vm console"
  xdg-open "$url" >/dev/null 2>&1 &
}

function ophelp() {
  local -A desc=(
    [openv]="Activate an OpenStack cloud (fzf if no arg)"
    [opoff]="Deactivate the current OpenStack cloud"
    [opexit]="alias: opoff"
    [opclear]="alias: opoff"
    [opwho]="Show active cloud (secrets redacted)"
    [opstatus]="alias: opwho"
    [opls]="List clouds in clouds.yaml"
    [opclouds]="alias: opls"
    [opcheck]="Validate the active cloud's credentials/token"
    [op]="openstack"
    [ops]="openstack server list"
    [opsa]="openstack server list --all-projects"
    [opss]="openstack server show"
    [opsr]="openstack server reboot"
    [opsh]="openstack server stop"
    [opst]="openstack server start"
    [opsdel]="openstack server delete"
    [oplog]="openstack console log show"
    [opnet]="openstack network list"
    [opsub]="openstack subnet list"
    [oprtr]="openstack router list"
    [opfip]="openstack floating ip list"
    [opip]="openstack floating ip list"
    [opsec]="openstack security group list"
    [opsecr]="openstack security group rule list"
    [opport]="openstack port list"
    [opvol]="openstack volume list"
    [opvola]="openstack volume list --all-projects"
    [opsnap]="openstack volume snapshot list"
    [opimg]="openstack image list"
    [opproj]="openstack project list"
    [opuser]="openstack user list"
    [oprole]="openstack role list"
    [optoken]="openstack token issue"
    [opfl]="openstack flavor list"
    [opkey]="openstack keypair list"
    [oplim]="openstack limits show --absolute"
    [oplb]="openstack loadbalancer list"
    [ops-ssh]="fzf-pick a server on the active cloud and ssh to it"
    [ops-console]="fzf-pick a server and open its noVNC console in the browser"
    [op_prompt_info]="Print '☁️  <cloud>' for prompt integration"
  )

  local groups=(
    "Cloud switching" openv opoff opexit opclear opwho opstatus opls opclouds opcheck
    "Compute" op ops opsa opss opsr opsh opst opsdel oplog
    "Networking" opnet opsub oprtr opfip opip opsec opsecr opport
    "Storage & images" opvol opvola opsnap opimg
    "Identity" opproj opuser oprole optoken opfl opkey oplim
    "Load balancers" oplb
    "Interactive" ops-ssh ops-console op_prompt_info
  )

  for entry in "${groups[@]}"; do
    if [[ -n "${desc[$entry]+x}" ]]; then
      printf '  %-14s %s\n' "$entry" "${desc[$entry]}"
    else
      echo
      echo "$entry:"
    fi
  done
}
