class Galen < Formula
  desc "Automated testing of look and feel for responsive websites"
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-2.0.7/galen-bin-2.0.7.zip"
  sha256 "cbc041e3bdb975aa75ff2e76196f0610fddfb89540ffe23293368e3024ce118e"

  bottle do
    cellar :any
    sha256 "8ec063b71f1a2b8fa8bb2b2b7b8e134869a799b470b1f62894aa1a05bc416542" => :yosemite
    sha256 "20e16c709f91f018b21fbf188e859e2606e6801742492f9393d4faeefe41f7c6" => :mavericks
    sha256 "554536bd7cdd05a809bdaea17f074af34824eee1ce286086e4ccb7966567d8a9" => :mountain_lion
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
