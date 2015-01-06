class Lout < Formula
  homepage "https://savannah.nongnu.org/projects/lout"
  url "http://download.savannah.gnu.org/releases/lout/lout-3.40.tar.gz"
  sha1 "adb7f632202319a370eaada162fa52cf334f40b3"

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
