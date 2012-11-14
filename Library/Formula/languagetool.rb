require 'formula'

class Languagetool < Formula
  homepage 'http://www.languagetool.org/'
  url 'http://www.languagetool.org/download/LanguageTool-1.3.1.oxt'
  sha1 'eed879e201f13dd98d585e945b21cd7ba3eacd20'

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'LanguageTool.jar', 'languagetool'
  end
end
