class MupdfTools < Formula
  homepage "http://mupdf.com"
  url "http://mupdf.com/downloads/mupdf-1.6-source.tar.gz"
  sha1 "491d7a3b131589791c7df6dd8161c6bfe41ce74a"
  head "git://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any
    sha1 "e1166cfdfd12e55f1e6181b6ef773018288ebd23" => :yosemite
    sha1 "2c1e660770d70d04ab1a637d7f50c0991e16ea9f" => :mavericks
    sha1 "924ea1f07a4dc79daba2a6233d4c5ac93c691662" => :mountain_lion
  end

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
    assert_match /Homebrew test/, shell_output("#{bin}/mudraw -t #{pdf}")
  end
end
