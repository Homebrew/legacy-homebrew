require 'formula'

class Languagetool < Formula
  homepage 'http://www.languagetool.org/'
  url 'https://www.languagetool.org/download/LanguageTool-2.6.zip'
  sha1 "bb9f1fe968aab655c22c94691013766bf0607936"

  def server_script server_jar; <<-EOS.undent
    #!/bin/bash
    exec java -cp #{server_jar} org.languagetool.server.HTTPServer "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'languagetool-commandline.jar', 'languagetool'
    (bin+'languagetool-server').write server_script(libexec/'languagetool-server.jar')
    bin.write_jar_script libexec/'languagetool.jar', 'languagetool-gui'
  end
end
