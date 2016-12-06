require 'formula'

class Jshint < Formula
  head 'https://github.com/jshint/jshint.git'
  homepage 'http://jshint.com/'

  depends_on 'rhino'

  def startup_script
    return <<-END
#!/bin/bash
cd #{libexec}/jshint/
rhino env/jshint-rhino.js $@
END
  end

  def install

    system "test -d dist/jshint || mkdir -p dist/jshint"
    system "rm -rf dist/jshint/*"
    system "cp -R env dist/jshint/"
    system "cp jshint.js dist/jshint/"

    libexec.install Dir["dist/jshint"]

    (bin+'jshint').write startup_script
  end
end
