class Galen < Formula
  desc "Automated testing of look and feel for responsive websites"
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-2.0.9/galen-bin-2.0.9.zip"
  sha256 "2fbafefc007cc3204e63ff73945470f1a76d6fbf993998c506bb2f1f1d1a4cb0"

  bottle do
    cellar :any
    sha256 "733d0d600bd451e49a7dfb53d5c7be98779161024abce9b1c5ac6e3e34bbafc1" => :yosemite
    sha256 "fd13eb41d3b84d74e99bae06f0e52cbfdcb5b3093e789d0e97044abb4abbc572" => :mavericks
    sha256 "fb89abc54c797a6e9316a733cb4b22eeb6e47df20ae1362404ee2c6e9144e9ac" => :mountain_lion
  end

  depends_on :java => "1.6+"

  def install
    libexec.install "galen.jar"
    (bin/"galen").write <<-EOS.undent
      #!/bin/sh
      set -e
      java -cp "#{libexec}/galen.jar:lib/*:libs/*" com.galenframework.GalenMain "$@"
    EOS
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/galen -v")
  end
end
