class Sgrep < Formula
  desc "Search SGML, XML, and HTML"
  homepage "https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html"
  url "ftp://ftp.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.94a.tar.gz"
  mirror "https://fossies.org/linux/misc/sgrep-1.94a.tar.gz"
  sha256 "d5b16478e3ab44735e24283d2d895d2c9c80139c95228df3bdb2ac446395faf9"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--datadir=#{share}/sgrep"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.eps")
    assert_equal "2", shell_output("#{bin}/sgrep -c '\"mark\"' #{input}").strip
  end
end
