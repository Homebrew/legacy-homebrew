class Galen < Formula
  desc "Automated testing of look and feel for responsive websites"
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-2.0.7/galen-bin-2.0.7.zip"
  sha256 "cbc041e3bdb975aa75ff2e76196f0610fddfb89540ffe23293368e3024ce118e"

  bottle do
    cellar :any
    sha256 "a8896697000cc717132626a3a5594f6a1f4c2dd8a3a6b51b380e14204621b724" => :yosemite
    sha256 "061e77f0cd75b2ddbf2c372373f5d7ae7e72546b2bd43dba8c0dbd43fd62ca9c" => :mavericks
    sha256 "97b5096a5a3130854aca1dd34b0a1b6f1e5f31c3364ff77be6900e0e6342922f" => :mountain_lion
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
