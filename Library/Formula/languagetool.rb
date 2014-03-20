require 'formula'

class Languagetool < Formula
  homepage 'http://www.languagetool.org/'
  url 'https://www.languagetool.org/download/LanguageTool-2.4.1.zip'
  sha1 '47ca4ee2da377450056eb386a2b88e4a077a94a5'

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
