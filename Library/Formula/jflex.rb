class Jflex < Formula
  desc "Lexical analyzer generator for Java, written in Java."
  homepage "http://jflex.de/"
  url "http://jflex.de/release/jflex-1.6.1.zip"
  sha256 "6da3c573db065f535c9b544e46ab4d49caa629b0354f8340df027f35e3368a51"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    pkgshare.install "examples"
    libexec.install "lib/jflex-#{version}.jar"
    bin.write_jar_script libexec/"jflex-#{version}.jar", "jflex"
  end

  test do
    system bin/"jflex", "-d", testpath, pkgshare/"examples/java/java.flex"
    assert_match /public static void/, (testpath/"Scanner.java").read
  end
end
