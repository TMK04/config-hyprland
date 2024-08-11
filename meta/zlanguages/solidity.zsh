# Add any commands which depend on go here
lazy_forge_aliases=('forge')

load_forge() {
  for lazy_forge_alias in $lazy_forge_aliases
  do
    unalias $lazy_forge_alias
  done

  load_rust

  unfunction load_forge
}

for lazy_forge_alias in $lazy_forge_aliases
do
  alias $lazy_forge_alias="load_forge && $lazy_forge_alias"
done
