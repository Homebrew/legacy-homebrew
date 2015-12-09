class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage "https://www.gnu.org/software/kawa/"
  url "http://ftpmirror.gnu.org/kawa/kawa-2.0.jar"
  mirror "https://ftp.gnu.org/gnu/kawa/kawa-2.0.jar"
  sha256 "dc5605950c9ab197a95337dbd241c369e8341a4f101072995f791d5fd2bf0400"

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
