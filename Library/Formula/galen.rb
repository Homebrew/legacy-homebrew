class Galen < Formula
  desc "Automated testing of look and feel for responsive websites"
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-2.0.8/galen-bin-2.0.8.zip"
  sha256 "57f2f028e4ec78ca3039cb3278918ea6889f2b9716d84dc8407407433903897a"

  bottle do
    cellar :any
    sha256 "9655deff99c99123122b3826b67198b3ec736395f4c3c1c011b90fd069b848a7" => :yosemite
    sha256 "6b47f4c1a895068fd7d86395add7b84cd6623b74c26a1e2adc5f0f62fad613f4" => :mavericks
    sha256 "09e3a2219e3ed6f8d117c0d6a594c54bfd331a426be39e3471067dbd71d2e09d" => :mountain_lion
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
