require "formula"

class Bfg < Formula
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://repo1.maven.org/maven2/com/madgag/bfg/1.11.10/bfg-1.11.10.jar"
  sha1 "c514a5649e9440e4b174ccc46faf8c38c6fb824f"

  bottle do
    cellar :any
    sha1 "2d5f40dcbeccdf9629d9a6a01ac6147ee27d625a" => :yosemite
    sha1 "cfb607b5fd0b9f4449d68516bc348171f9745232" => :mavericks
    sha1 "ee1a0dd42789fbfeaacd3c397224f52873eab98f" => :mountain_lion
  end

  def install
    libexec.install "bfg-1.11.10.jar"
    bin.write_jar_script libexec/"bfg-1.11.10.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
