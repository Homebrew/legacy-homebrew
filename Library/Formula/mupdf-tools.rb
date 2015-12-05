class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "http://mupdf.com"
  url "http://mupdf.com/downloads/mupdf-1.8-source.tar.gz"
  sha256 "a2a3c64d8b24920f87cf4ea9339a25abf7388496440f13b37482d1403c33c206"
  head "git://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any
    sha256 "21ff024a9bd04efa139395d6e5a83384ea24ebe3be3f4fd30baa2c5317ba20ce" => :el_capitan
    sha256 "337686c7beaa9aea353c270991110c8a15b7769125ef61945f16bd1d0cd53bd8" => :yosemite
    sha256 "808814594e6b2ccfbf644f45b0676c6913cf33c16766a0b70ed62449b69fa2bf" => :mavericks
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
    assert_match /Homebrew test/, shell_output("#{bin}/mutool draw -F txt #{pdf}")
  end
end
