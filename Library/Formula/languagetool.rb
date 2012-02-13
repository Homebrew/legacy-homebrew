require 'formula'

class Languagetool < Formula
  homepage 'http://www.languagetool.org/'
  url 'http://www.languagetool.org/download/LanguageTool-1.3.1.oxt'
  md5 '9bf13c617eba946fd6b44562cbc90d42'

  def install
    (bin+"languagetool").write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/LanguageTool.jar" "$@"
    EOS

    libexec.install Dir["*"]
  end
end
