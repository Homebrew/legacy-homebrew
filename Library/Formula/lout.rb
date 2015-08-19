class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "http://download.savannah.gnu.org/releases/lout/lout-3.40.tar.gz"
  sha256 "3d16f1ce3373ed96419ba57399c2e4d94f88613c2cb4968cb0331ecac3da68bd"

  bottle do
    sha1 "104638e651e1978c63efe05e4fc7a862c508bc04" => :yosemite
    sha1 "8b523c9ebd004613a18bc212d840532db4089f40" => :mavericks
    sha1 "7743b80e1fae54efe71f90c7a9d632a3dfbdcfc0" => :mountain_lion
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
