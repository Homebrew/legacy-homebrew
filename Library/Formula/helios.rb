require "formula"

class Helios < Formula
  homepage "https://github.com/spotify/helios"
  url "https://oss.sonatype.org/service/local/repositories/releases/content/com/spotify/helios-tools/0.8.41/helios-tools-0.8.41-shaded.jar"
  sha1 "3a8d464494a36bea3bd81e28d10c64cb331cc3dc"
  version "0.8.41"

  depends_on :java => "1.7"

  def install
    libexec.install "helios-tools-0.8.41-shaded.jar"
    bin.write_jar_script libexec/"helios-tools-0.8.41-shaded.jar", "helios"
  end

  test do
    system "#{bin}/helios", "--version"
  end
end
