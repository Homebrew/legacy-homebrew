require "formula"

class Helios < Formula
  homepage "https://github.com/spotify/helios"
  url "https://oss.sonatype.org/service/local/repositories/releases/content/com/spotify/helios-tools/0.8.69/helios-tools-0.8.69-shaded.jar"
  sha1 "2fbd397d2fb7520d1ec19b5eb7e82a34e083fb3f"
  version "0.8.69"

  depends_on :java => "1.7"

  def install
    libexec.install "helios-tools-0.8.69-shaded.jar"
    bin.write_jar_script libexec/"helios-tools-0.8.69-shaded.jar", "helios"
  end

  test do
    system "#{bin}/helios", "--version"
  end
end
