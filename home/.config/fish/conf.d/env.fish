fish_add_path -g ~/.local/bin

if type -q mise
    mise activate fish | source
end

# Greet each new interactive shell with fastfetch.
if status is-interactive
    fastfetch
end
