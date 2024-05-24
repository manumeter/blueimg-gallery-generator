#!/bin/bash

#
# Requirements:
#   - git
#   - convert (imagemagick)
#

CWD="$(dirname "$(readlink -f "$0")")"

#
# Update BlueImp Gallery
#

if [ ! -d "$CWD/js" -o ! -d "$CWD/css" -o ! -d "$CWD/img" ]; then
    git clone https://github.com/blueimp/Gallery.git /tmp/gallery
    [ ! -d "$CWD/js" ] && mkdir "$CWD/js" && cp -r /tmp/gallery/js/* "$CWD/js/"
    [ ! -d "$CWD/css" ] && mkdir "$CWD/css" && cp -r /tmp/gallery/css/* "$CWD/css/"
    [ ! -d "$CWD/img" ] && mkdir "$CWD/img" && cp -r /tmp/gallery/img/* "$CWD/img/"
    rm -rf /tmp/gallery
fi

#
# Generate Thumbnails
#

rm -rf "$CWD/thumbs"
mkdir "$CWD/thumbs"

(
cd "$CWD/gallery"
for g in *; do
    if [ -d "$CWD/gallery/$g" ]; then
        mkdir "$CWD/thumbs/$g"
        for i in "$g"/*.jpg; do
            convert -define jpeg:size=200x200 "$CWD/gallery/$i" -thumbnail 100x100^ -gravity center -extent 100x100 "$CWD/thumbs/$i"
        done
    fi
done
)

#
# Generate HTML
#

cat "$CWD/index.html.head" > "$CWD/index.html"
[ -f "$CWD/gallery/HEAD.html" ] && cat "$CWD/gallery/HEAD.html" >> "$CWD/index.html"

(
cd "$CWD/gallery"
for g in *; do
    if [ -d "$CWD/gallery/$g" ]; then
        echo '<h2>'"$g"'</h2>' >> "$CWD/index.html"
        [ -f "$CWD/gallery/$g/HEAD.html" ] && cat "$CWD/gallery/$g/HEAD.html" >> "$CWD/index.html"
        echo '<div class="gallery">' >> "$CWD/index.html"
        for i in "$g"/*.jpg; do
            echo '<a href="'"gallery/$i"'"><img src="thumbs/'"$i"'"></a>' >> "$CWD/index.html"
        done
        [ -f "$CWD/gallery/$g/TAIL.html" ] && cat "$CWD/gallery/$g/TAIL.html" >> "$CWD/index.html"
        echo '</div>' >> "$CWD/index.html"
    fi
done
)

[ -f "$CWD/gallery/TAIL.html" ] && cat "$CWD/gallery/TAIL.html" >> "$CWD/index.html"
cat "$CWD/index.html.tail" >> "$CWD/index.html"
