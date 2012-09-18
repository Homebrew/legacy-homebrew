require 'formula'

class Languagetool < Formula
  homepage 'http://www.languagetool.org/'
  url 'http://www.languagetool.org/download/LanguageTool-1.3.1.oxt'
  sha1 'eed879e201f13dd98d585e945b21cd7ba3eacd20'

  def install
    (bin+"languagetool").write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/LanguageTool.jar" "$@"
    EOS

    libexec.install Dir["*"]
  end
end
