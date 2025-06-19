override=(
	--filesystem=~/.themes
	--filesystem=~/.local/share/themes
	--filesystem=~/.icons
	--filesystem=~/.local/share/icons
	--filesystem=~/.fonts
	--filesystem=~/.local/share/fonts
	--filesystem=~/.config/gtk-4.0
)

for flatpak in "${override[@]}"; do
	sudo flatpak override "$flatpak"
done
