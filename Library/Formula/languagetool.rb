class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://www.languagetool.org/download/LanguageTool-3.2.zip"
  sha256 "9dca4596de39d4a83ed762f3125decd3b12057c8069b8107e2869b2993280f09"

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

  test do
    pipe_output("#{bin}/languagetool -l en-US -", "This is a test.")
  end
end
