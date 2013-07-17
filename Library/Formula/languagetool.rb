require 'formula'

class Languagetool < Formula
  homepage 'http://www.languagetool.org/'
  url 'http://www.languagetool.org/download/LanguageTool-2.2.zip'
  sha1 '7df7e702cbc97da228f1ba0fd648a6e8f3fc3610'

  def server_script server_jar; <<-EOS.undent
    #!/bin/bash
    exec java -cp #{server_jar} org.languagetool.server.HTTPServer "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'languagetool-commandline.jar', 'languagetool'
    (bin+'languagetool-server').write server_script(libexec/'languagetool-server.jar')
    bin.write_jar_script libexec/'languagetool-standalone.jar', 'languagetool-gui'
  end
end
