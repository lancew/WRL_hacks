# Simple build script so to speak.
#
# fix/tidy the javascript
jscs wrl.js -x
#
# FIXME: Run JSHint over script
#jshint wrl.js
# compress the js
uglifyjs -c -o wrl-min.js wrl.js --source-map wrl-min.js.map --source-map-url
# TODO: Then can we compress the css itself?

