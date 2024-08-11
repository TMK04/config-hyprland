ngrok_copy() {
  curl -s localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url' | pbcopy
}

ngrok_and_copy() {
  local to_copy=0
  case "$1" in
    copy)
      ngrok_copy
      return
      ;;
    http|start|tcp|tunnel)
      if [ -n "$2" ]; then
        case "$2" in
          --help|-h|--metadata|--version|-v)
            to_copy=0
            ;;
          *)
            to_copy=1
            ;;
        esac
      else
        to_copy=1
      fi
  esac

  if [ $to_copy -eq 1 ]; then
    { sleep 2; ngrok_copy; } &
  fi

  ngrok ${=@}
}

alias ngrok="ngrok_and_copy"
