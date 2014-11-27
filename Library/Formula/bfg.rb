require "formula"

class Bfg < Formula
  homepage "http://rtyley.github.io/bfg-repo-cleaner/"
  url "http://repo1.maven.org/maven2/com/madgag/bfg/1.11.8/bfg-1.11.8.jar"
  sha1 "9834ed826f2b3f1da1f28f663e3c5b9cf807ab1e"

  bottle do
    cellar :any
    sha1 "2d5f40dcbeccdf9629d9a6a01ac6147ee27d625a" => :yosemite
    sha1 "cfb607b5fd0b9f4449d68516bc348171f9745232" => :mavericks
    sha1 "ee1a0dd42789fbfeaacd3c397224f52873eab98f" => :mountain_lion
  end

  def install
    libexec.install "bfg-1.11.8.jar"
    bin.write_jar_script libexec/"bfg-1.11.8.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
