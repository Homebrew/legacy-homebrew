class Ditaa < Formula
  desc "Convert ASCII diagrams into proper bitmap graphics"
  homepage "http://ditaa.sourceforge.net/"
  url "https://github.com/stathissideris/ditaa/archive/v0.10.tar.gz"
  sha256 "82e49065d408cba8b323eea0b7f49899578336d566096c6eb6e2d0a28745d63b"

  depends_on :ant => :build
  depends_on :java

  def install
    mkdir "bin"
    system "ant", "-buildfile", "build/release.xml", "release-jar"
    mv "releases/ditaa0_9.jar", "releases/ditaa0_10.jar"
    libexec.install "releases/ditaa0_10.jar"
    bin.write_jar_script libexec/"ditaa0_10.jar", "ditaa"
  end

  test do
    system "#{bin}/ditaa", "-help"
  end
end
