require 'formula'

class Languagetool < Formula
  homepage 'http://www.languagetool.org/'
  url 'https://www.languagetool.org/download/LanguageTool-2.7.zip'
  sha1 "dfc1f99da854cfd91c39c43eb19c058e0eaff500"

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
