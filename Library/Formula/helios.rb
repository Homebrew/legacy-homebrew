require "formula"

class Helios < Formula
  homepage "https://github.com/spotify/helios"
  url "https://oss.sonatype.org/service/local/repositories/releases/content/com/spotify/helios-tools/0.8.77/helios-tools-0.8.77-shaded.jar"
  sha1 "15684178cf0a7d07db425a50f7371749a122846e"
  version "0.8.77"

  depends_on :java => "1.7"

  def install
    libexec.install "helios-tools-#{version}-shaded.jar"
    bin.write_jar_script libexec/"helios-tools-#{version}-shaded.jar", "helios"
  end

  test do
    system "#{bin}/helios", "--version"
  end
end
