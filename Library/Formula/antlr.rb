require 'formula'

class Antlr < Formula
  homepage 'http://www.antlr.org/'
  url 'http://www.antlr.org/download/antlr-4.0-complete.jar'
  sha1 '6186fb2d530fa822251224250cbf55a238f248ac'

  def install
    prefix.install "antlr-4.0-complete.jar"
    bin.write_jar_script prefix/"antlr-4.0-complete.jar", "antlr4"
  end
end
