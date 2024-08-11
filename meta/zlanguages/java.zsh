# Add any commands which depend on java here
lazy_java_aliases=('java' 'jenv')

load_java() {
  for lazy_java_alias in $lazy_java_aliases
  do
    unalias $lazy_java_alias
  done

  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"

  unfunction load_java
}

for lazy_java_alias in $lazy_java_aliases
do
  alias $lazy_java_alias="load_java && $lazy_java_alias"
done
