# Simple build script so to speak.
#
# First compress the js
uglifyjs -c -o wrl-min.js wrl.js --source-map wrl-min.js.map --source-map-url
# TODO: Then can we compress the css itself?

