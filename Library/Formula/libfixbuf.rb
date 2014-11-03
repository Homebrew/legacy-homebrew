require "formula"

class Libfixbuf < Formula
  homepage "http://tools.netsa.cert.org/fixbuf/"
  url "http://tools.netsa.cert.org/releases/libfixbuf-1.6.1.tar.gz"
  sha1 "5362e7ae866c418b1ae5576ad9ea3095bd7f2681"

  bottle do
    cellar :any
    revision 1
    sha1 "60c700ab713836edb6801bb269f7df2cefc2bbf0" => :yosemite
    sha1 "58cd2e290fff5892a5e71d660755da72634e3ee2" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
