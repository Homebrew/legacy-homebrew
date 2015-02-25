class MupdfTools < Formula
  homepage "http://mupdf.com"
  url "http://mupdf.com/downloads/mupdf-1.6-source.tar.gz"
  sha1 "491d7a3b131589791c7df6dd8161c6bfe41ce74a"
  head "git://git.ghostscript.com/mupdf.git"

  depends_on :macos => :snow_leopard
  depends_on "openssl"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_match /Homebrew test/, shell_output("#{bin}/mudraw -t #{pdf} 2>/dev/null")
  end
end
