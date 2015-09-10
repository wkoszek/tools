#!/usr/bin/env node

var fs = require('fs')
toMarkdown = require('to-markdown');

fn = process.argv[2]

fs.readFile(fn, 'utf8', function (err,data) {
	if (err) {
		return console.log(err);
	}
	converter = {
		filter: ['span', 'title', 'meta', 'style'],
		replacement: function(content) {
			if (
				content.tagName == 'style' ||
				content.tagName == 'meta' ||
				content.tagName == 'title'
			) {
				return "";
			}
			return content;
		}
	};

	v = toMarkdown(data, { converters: [converter] });

	console.log(v);
});

