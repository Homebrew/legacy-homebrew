require 'formula'

class Languagetool < Formula
  url 'http://www.languagetool.org/download/LanguageTool-1.3.1.oxt'
  homepage 'http://www.languagetool.org/'
  md5 '9bf13c617eba946fd6b44562cbc90d42'

  def startup_script
    <<-EOS
#!/bin/bash
java -jar #{libexec}/LanguageTool.jar $*
EOS
  end

  def install
    (bin+"languagetool").write startup_script
    libexec.install Dir["*"]
  end
end
