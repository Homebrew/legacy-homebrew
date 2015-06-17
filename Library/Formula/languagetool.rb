require 'formula'

class Languagetool < Formula
  desc "Style and grammar checker"
  homepage 'http://www.languagetool.org/'
  url 'https://www.languagetool.org/download/LanguageTool-2.8.zip'
  sha1 "38b0787d9b4305aa7c71942011b7668a312ffbc1"

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
