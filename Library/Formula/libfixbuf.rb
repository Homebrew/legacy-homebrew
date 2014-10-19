require "formula"

class Libfixbuf < Formula
  homepage "http://tools.netsa.cert.org/fixbuf/"
  url "http://tools.netsa.cert.org/releases/libfixbuf-1.5.0.tar.gz"
  sha1 "6e77c2ec1ee32514454ad1fff6494265c583e72c"

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
