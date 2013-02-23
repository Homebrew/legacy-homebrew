require 'formula'

class Languagetool < Formula
  homepage 'http://www.languagetool.org/'
  url 'http://www.languagetool.org/download/LanguageTool-2.0.oxt'
  sha1 'f21589f77511656bb7ca5e83b4c22f1660eb96d8'

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'LanguageTool.jar', 'languagetool'
  end
end
