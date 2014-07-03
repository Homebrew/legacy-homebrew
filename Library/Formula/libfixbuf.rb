require "formula"

class Libfixbuf < Formula
  homepage "http://tools.netsa.cert.org/fixbuf/"
  url "http://tools.netsa.cert.org/releases/libfixbuf-1.5.0.tar.gz"
  sha1 "6e77c2ec1ee32514454ad1fff6494265c583e72c"

  bottle do
    cellar :any
    sha1 "0e55b16b511a8719219c97b3ae14284845cd6ee1" => :mavericks
    sha1 "acfed7df74766b4a2a4d20e73d07657ea683b5ff" => :mountain_lion
    sha1 "bea6a050f70031c1ca7998b7be77be39d8b9c815" => :lion
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
