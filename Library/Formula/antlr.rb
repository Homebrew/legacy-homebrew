require 'formula'

class Antlr < Formula
  homepage 'http://www.antlr.org/'
  url 'http://www.antlr.org/download/antlr-4.1-complete.jar'
  sha1 '2f80d904ab786d0616560085d30d402e90b9880a'

  def install
    prefix.install "antlr-4.1-complete.jar"
    bin.write_jar_script prefix/"antlr-4.1-complete.jar", "antlr4"
  end
end
