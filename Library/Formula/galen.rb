class Galen < Formula
  desc "Automated testing of look and feel for responsive websites"
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-2.0.10/galen-bin-2.0.10.zip"
  sha256 "cd014d28b29835d3e0ed06c585b05e1ccf8cf1a1a68ceb9a5b6584497f3bd321"

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
