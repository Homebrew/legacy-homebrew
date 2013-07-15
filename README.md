<<<<<<< HEAD
# Homebrew webpage

The webpage uses [jekyll](https://github.com/mojombo/jekyll). The template for the index is at layouts/index.html.

## Translations
If you want to add a new translation, follow these steps:

1. In _config.yml append this:

	```
	- langcode: {the_lang_code}
	  lang_string: {the_link_string}
	```
2. Copy index.html as index_{langcode}.html
3. Change the values of the strings to the translated strings.

You can see the translated webpage by running `jekyll --server` and opening http://localhost:4000/
=======
Homebrew
========
Features, usage and installation instructions are [summarized on the homepage][home].

What Packages Are Available?
----------------------------
1. You can [browse the Formula directory on GitHub][formula].
2. Or type `brew search` for a list.
3. Or run `brew server` to browse packages off of a local web server.
4. Or visit [braumeister.org][braumeister] to browse packages online.

More Documentation
------------------
`brew help` or `man brew` or check our [wiki][].

Who Are You?
------------
I'm [Max Howell][mxcl] and I'm a splendid chap.

License
-------
Code is under the [BSD 2 Clause (NetBSD) license][license].

[home]:http://brew.sh
[wiki]:http://wiki.github.com/mxcl/homebrew
[mxcl]:http://twitter.com/mxcl
[formula]:http://github.com/mxcl/homebrew/tree/master/Library/Formula/
[braumeister]:http://braumeister.org
[license]:https://github.com/mxcl/homebrew/tree/master/Library/Homebrew/LICENSE
>>>>>>> origin/wine-x11
