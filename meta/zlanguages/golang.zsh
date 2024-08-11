# Add any commands which depend on golang here
lazy_golang_aliases=('goenv' 'go')

load_golang() {
  for lazy_golang_alias in $lazy_golang_aliases
  do
    unalias $lazy_golang_alias
  done

  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
  export PATH="$GOROOT/bin:$PATH"
  export PATH="$PATH:$GOPATH/bin"

  unfunction load_golang
}

for lazy_golang_alias in $lazy_golang_aliases
do
  alias $lazy_golang_alias="load_golang && $lazy_golang_alias"
done
