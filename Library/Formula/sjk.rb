class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://bintray.com/artifact/download/aragozin/generic/sjk-plus-0.3.6.jar"
  sha256 "9420403139c1b843320fe07bac56f704b0d13715d53b5b2b5869d32103a99a47"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install "sjk-plus-#{version}.jar"
    bin.write_jar_script "#{libexec}/sjk-plus-#{version}.jar", "sjk"
  end

  test do
    system "#{bin}/sjk", "jps"
  end
end
