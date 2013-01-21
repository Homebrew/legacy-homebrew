require 'formula'

class Antlr < Formula
  homepage 'http://www.antlr.org/'
  url 'http://www.antlr.org/download/antlr-3.5-complete.jar'
  sha1 'f552792c4cdceb8c02fa1354e773349763267ab9'

  def install
    prefix.install "antlr-3.5-complete.jar"
    bin.write_jar_script prefix/"antlr-3.5-complete.jar", "antlr-3.4"
  end
end
