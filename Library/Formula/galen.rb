class Galen < Formula
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-1.5.4/galen-bin-1.5.4.zip"
  sha256 "0bfc74726068feb8c95926087adf43690fad9ce43e3c3aaa5f36850eb43df53b"

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
