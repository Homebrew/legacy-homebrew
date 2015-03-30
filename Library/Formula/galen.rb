class Galen < Formula
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-1.6.0/galen-bin-1.6.0.zip"
  sha256 "b205734f6f460c2e1663b5bc9f7a009f9c0ab1ec9075e9a2cbd32e60ea2f2562"

  depends_on :java => "1.6+"

  def install
    libexec.install "galen.jar"
    (bin/"galen").write <<-EOS.undent
      #!/bin/sh
      set -e
      java -cp "#{libexec}/galen.jar:lib/*:libs/*" net.mindengine.galen.GalenMain "$@"
    EOS
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/galen -v")
  end
end
