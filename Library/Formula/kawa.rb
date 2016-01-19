class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage "https://www.gnu.org/software/kawa/"
  url "http://ftpmirror.gnu.org/kawa/kawa-2.1.jar"
  mirror "https://ftp.gnu.org/gnu/kawa/kawa-2.1.jar"
  sha256 "d579e81d51c481222a5bfd12098bf0f292a3e7c9754d508c4a0686cced8c72af"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install "kawa-#{version}.jar"
    (bin/"kawa").write <<-EOS.undent
      #!/bin/sh
      KAWA_HOME="#{libexec}"
      java -jar "$KAWA_HOME/kawa-#{version}.jar"
    EOS
  end
end
