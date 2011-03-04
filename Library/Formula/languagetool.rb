require 'formula'

class Languagetool <Formula
  url 'http://www.languagetool.org/download/LanguageTool-1.1.oxt'
  homepage 'http://www.languagetool.org/'
  md5 '80abc0901135afa25385e519d44f802e'

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
