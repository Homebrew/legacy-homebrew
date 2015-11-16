class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://www.languagetool.org/download/LanguageTool-3.0.zip"
  sha256 "52f7b27a7c040db3e824bf115302ea0737a5f0b4573b0c012c2a26a96680fc3d"

  bottle :unneeded

  def server_script(server_jar); <<-EOS.undent
    #!/bin/bash
    exec java -cp #{server_jar} org.languagetool.server.HTTPServer "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"languagetool-commandline.jar", "languagetool"
    (bin+"languagetool-server").write server_script(libexec/"languagetool-server.jar")
    bin.write_jar_script libexec/"languagetool.jar", "languagetool-gui"
  end
end
