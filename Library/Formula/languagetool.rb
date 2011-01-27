require 'formula'

class Languagetool <Formula
  url 'http://www.languagetool.org/download/LanguageTool-1.0.0.oxt'
  homepage 'http://www.languagetool.org/'
  md5 '979b1a1f2ce3a9100d7aa7b1ef245734'

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
