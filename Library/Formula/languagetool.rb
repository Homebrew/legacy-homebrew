require 'formula'

class Languagetool < Formula
  homepage 'http://www.languagetool.org/'
  url 'http://www.languagetool.org/download/LanguageTool-2.1.oxt'
  sha1 '73310a2400378ea2fd302a6654df32a5b471aa3e'

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'LanguageTool.jar', 'languagetool'
  end
end
