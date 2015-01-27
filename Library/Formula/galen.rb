class Galen < Formula
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-1.5.1/galen-bin-1.5.1.zip"
  sha1 "ea3e261e0409c8797a3c627536444bfd4c5ff311"

  depends_on :java => "1.6"

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
