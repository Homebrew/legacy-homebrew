require "formula"

class Helios < Formula
  homepage "https://github.com/spotify/helios"
  url "https://oss.sonatype.org/service/local/repositories/releases/content/com/spotify/helios-tools/0.8.71/helios-tools-0.8.71-shaded.jar"
  sha1 "757ce4ad92774305ec4ec95f6786481b6419ec6b"
  version "0.8.71"

  depends_on :java => "1.7"

  def install
    libexec.install "helios-tools-0.8.71-shaded.jar"
    bin.write_jar_script libexec/"helios-tools-0.8.71-shaded.jar", "helios"
  end

  test do
    system "#{bin}/helios", "--version"
  end
end
