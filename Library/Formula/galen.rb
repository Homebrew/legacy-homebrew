class Galen < Formula
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-1.6.3/galen-bin-1.6.3.zip"
  sha256 "efd7cac3c6aed1f8630dbfa2ee51069c1d7551df457036c600d93fbc3f9c6ebf"

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
