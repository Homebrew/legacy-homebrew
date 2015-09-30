class Galen < Formula
  desc "Automated testing of look and feel for responsive websites"
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-2.1.2/galen-bin-2.1.2.zip"
  sha256 "46c94af882845bca40168860f5ed35630a0b5416d18c37f479807da86c1c067e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f4e2026e14cb405b18ce647a3d95a4220aefb1b7bd23600a0edd6fd869772ac" => :yosemite
    sha256 "9377554f54550709b890990693707bc18ccb35c8082e4d11efaca7f85218e758" => :mavericks
    sha256 "d057fe2c3b46cb5f364b3ac07af5e7cc81ec116369ae269ee485b56fad010780" => :mountain_lion
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
