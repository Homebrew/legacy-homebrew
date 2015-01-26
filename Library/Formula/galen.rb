class Galen < Formula
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/archive/galen-1.5.1.tar.gz"
  sha1 "a4089c4084b1d21a9c67bddb8df13933e818ad7e"

  depends_on :java => "1.6"
  depends_on "maven" => :build

  def install
    system "./makeDist.sh"
    libexec.install "dist/galen-bin-#{version}/galen.jar"
    (bin/"galen").write <<-EOS.undent
      #!/bin/sh
      set -e
      java -cp "#{libexec}/galen.jar:lib/*:libs/*" net.mindengine.galen.GalenMain "$@"
    EOS
  end

  test do
    output = shell_output "#{bin}/galen -v"
    assert_match /Galen Framework\nVersion: 1.5.1/, output
  end
end
