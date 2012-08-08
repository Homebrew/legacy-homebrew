require 'formula'

class Jsdoc3 < Formula
  homepage 'http://usejsdoc.org/'
  url 'https://github.com/jsdoc3/jsdoc/tarball/v3.0.1'
  sha1 '0c6ad2321d300a3eaa2e1d543f3fbf166ff1ce18'

  def install
    libexec.install Dir['*']

    # Custom invoker that just passes on whatever arguments you give it
    system "/bin/echo '#!/bin/sh' > jsdoc"
    system "/bin/echo '#{libexec}/jsdoc $@' >> jsdoc"

    bin.install "jsdoc"
  end
end
