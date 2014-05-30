name = ARGV.first

raise "A name is required" if name.nil?

template = <<-EOS
Homebrew-#{name}
=========#{'=' * name.size}

How do I install these formulae?
--------------------------------
Just `brew tap homebrew/#{name}` and then `brew install <formula>`.

If the formula conflicts with one from Homebrew/homebrew or another tap, you can `brew install homebrew/#{name}/<formula>`.

You can also install via URL:

```
brew install https://raw.github.com/Homebrew/homebrew-#{name}/master/<formula>.rb
```

Docs
----
`brew help`, `man brew`, or the Homebrew [wiki][].

[wiki]:http://wiki.github.com/Homebrew/homebrew
EOS

puts template if ARGV.verbose?
path = Pathname.new('./README.md')
raise "#{path} already exists" if path.exist?
path.write template
