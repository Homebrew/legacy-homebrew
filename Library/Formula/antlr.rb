require 'formula'

class Antlr < Formula
  homepage 'http://www.antlr.org/'
  url "http://www.antlr.org/download/antlr-3.4-complete.jar"
  sha1 '5cab59d859caa6598e28131d30dd2e89806db57f'

  def install
    prefix.install "antlr-3.4-complete.jar"
    bin.write_jar_script prefix/"antlr-3.4-complete.jar", "antlr-3.4"
  end
end
