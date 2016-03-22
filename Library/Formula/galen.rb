class Galen < Formula
  desc "Automated testing of look and feel for responsive websites"
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-2.2.3/galen-bin-2.2.3.zip"
  sha256 "1857c44261dd7211318d572fa2c253f6349df374e4a5bbd0ce023d64f8ea7b8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e2757741326c7310421e9cd917fba79e87c51b61a19c85084909acf29137798" => :el_capitan
    sha256 "737875be2287799f19342a6a14c70185dd56ede79dbb8213de9b31edeed8b054" => :yosemite
    sha256 "f95a0c017e09874d9b342c12e40bf4e8b75906070f67a5a479e45a81d41c66a1" => :mavericks
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
