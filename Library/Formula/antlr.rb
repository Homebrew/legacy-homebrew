require 'formula'

class Antlr < Formula
  homepage 'http://www.antlr.org/'
  url 'http://www.antlr.org/download/antlr-4.2.2-complete.jar'
  sha1 '97b3117463b6beda300ee7a297a31b71db9aea2b'

  def install
    prefix.install "antlr-#{version}-complete.jar"
    bin.write_jar_script prefix/"antlr-#{version}-complete.jar", "antlr4"
  end
end
