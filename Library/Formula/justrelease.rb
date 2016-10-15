class Justrelease < Formula
  desc "CLI tool to release github projects."
  homepage "https://github.com/justrelease"
  url "https://github.com/justrelease/justrelease/releases/download/v1.0.0/justrelease-1.0.0.zip"
  sha256 "46be6e3e9fa53e5c07f8a854de568f47ee64492989e6cc4d242cce0bf5544a8d"

  depends_on :java
  def install
       libexec.install "justrelease-#{version}.jar"
       (bin/"justrelease").write <<-EOS.undent
         #!/bin/sh
         JUSTRELEASE_HOME="#{libexec}"
         java -jar "$JUSTRELEASE_HOME/justrelease-#{version}.jar" $@
       EOS
  end
end