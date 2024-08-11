# Add any commands which depend on go here
lazy_rust_aliases=('cargo' 'rustc' 'rustup')

load_rust() {
  for lazy_rust_alias in $lazy_rust_aliases
  do
    unalias $lazy_rust_alias
  done

  . "$HOME/.cargo/env"

  unfunction load_rust
}

for lazy_rust_alias in $lazy_rust_aliases
do
  alias $lazy_rust_alias="load_rust && $lazy_rust_alias"
done
