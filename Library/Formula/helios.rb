require "formula"

class Helios < Formula
  homepage "https://github.com/spotify/helios"
  url "https://oss.sonatype.org/service/local/repositories/releases/content/com/spotify/helios-tools/0.8.80/helios-tools-0.8.80-shaded.jar"
  sha1 "dc846c57f836447f3dd1255db2c4f8598934b178"
  version "0.8.80"

  depends_on :java => "1.7"

  def install
    libexec.install "helios-tools-#{version}-shaded.jar"
    bin.write_jar_script libexec/"helios-tools-#{version}-shaded.jar", "helios"
  end

  test do
    system "#{bin}/helios", "--version"
  end
end
