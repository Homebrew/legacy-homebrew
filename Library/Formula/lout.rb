class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "http://download.savannah.gnu.org/releases/lout/lout-3.40.tar.gz"
  sha256 "3d16f1ce3373ed96419ba57399c2e4d94f88613c2cb4968cb0331ecac3da68bd"

  bottle do
    sha256 "366023d41536d0220a3d226a9f7a5e65b89fcf8ec212bfd6e53f8c2b4110abce" => :yosemite
    sha256 "7cbcdcbf720e5e93c7e8d41861fedbcb0f1b46233414c7897e94671e4e42a9fa" => :mavericks
    sha256 "9d3b44fdc1f1aa2f01ece78c63ad8084897d27758cf72cfbdef6f876c0c7a0cb" => :mountain_lion
  end

  def install
    bin.mkpath
    man1.mkpath
    (doc/"lout").mkpath
    system "make", "PREFIX=#{prefix}", "LOUTLIBDIR=#{lib}", "LOUTDOCDIR=#{doc}", "MANDIR=#{man}", "allinstall"
  end

  test do
    input = "test.lout"
    (testpath/input).write <<-EOS.undent
      @SysInclude { doc }
      @Doc @Text @Begin
      @Display @Heading { Blindtext }
      The quick brown fox jumps over the lazy dog.
      @End @Text
    EOS
    assert_match /^\s+Blindtext\s+The quick brown fox.*\n+$/, shell_output("#{bin}/lout -p #{input}")
  end
end
