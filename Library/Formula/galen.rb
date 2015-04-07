class Galen < Formula
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-1.6.2/galen-bin-1.6.2.zip"
  sha256 "e4978a79e8acc854a94999b83398490b5600ed67450d0adc9b0bb319be3a70d6"

  bottle do
    cellar :any
    sha256 "f1d64ada4b7bfb1fa27e9f1b849a385c316f76b3f677e8fbd002c9d0c6460b34" => :yosemite
    sha256 "334ad1672f09933ff04da6ff48f777408167143e077aabb4b8cdbe7f42552e62" => :mavericks
    sha256 "e5a9b03e0a764bef6a4e0efa19ba89e18d4d1b63157dd0e77e6fa97740182a33" => :mountain_lion
  end

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
