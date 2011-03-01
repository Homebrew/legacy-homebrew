require 'formula'

class Languagetool <Formula
  url 'http://www.languagetool.org/download/LanguageTool-1.2.oxt'
  homepage 'http://www.languagetool.org/'
  md5 'f13ea47708968b2eb484f84623dd74e4'

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
