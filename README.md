# blueimp Gallery generator

This is a simple shell script to generate a nice blueimp single-page image
gallery list from directories with JPG images and HTML files.

Just create one directory per gallery in `/gallery` containing all the JPG
images. In each directory (`/gallery` and `/gallery/*/`) a `HEAD.html` and
`TAIL.html` can be created to add custom HTML (like description text etc.).

The script pulls the `css` and `js` from blueimp, generates thumbnails of all
images and builds the `index.html` according to the directory structure.
