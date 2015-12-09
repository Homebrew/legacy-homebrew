class Galen < Formula
  desc "Automated testing of look and feel for responsive websites"
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-2.2.1/galen-bin-2.2.1.zip"
  sha256 "1c7cc172a1d3a91ca6b949e2c4f12d8d957c1e5fa4be512aa4a6a021b01a30f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c50e9a0f39897ffe312bf824fd794eb523d4f75593bc238579ce23d845d7b32" => :el_capitan
    sha256 "b49698fc9eaf74f1a14793750aab2ca9338236704fd09f691b1cb5737e3168b7" => :yosemite
    sha256 "f1929d8d35e9044e73edf225be7c95eb3e1c0eeae745c8604bf239fccbb33aba" => :mavericks
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
