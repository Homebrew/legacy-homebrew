require "formula"

class Helios < Formula
  homepage "https://github.com/spotify/helios"
  url "https://oss.sonatype.org/service/local/repositories/releases/content/com/spotify/helios-tools/0.8.76/helios-tools-0.8.76-shaded.jar"
  sha1 "1da57909be1415644cb0613a8c3d6a481682ea75"
  version "0.8.76"

  depends_on :java => "1.7"

  def install
    libexec.install "helios-tools-0.8.76-shaded.jar"
    bin.write_jar_script libexec/"helios-tools-0.8.76-shaded.jar", "helios"
  end

  test do
    system "#{bin}/helios", "--version"
  end
end
