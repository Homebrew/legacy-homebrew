class Libspiro < Formula
  desc "Library to simplify the drawing of curves"
  homepage "https://github.com/fontforge/libspiro"
  url "https://downloads.sourceforge.net/project/libspiro/libspiro/20071029/libspiro_src-20071029.tar.bz2"
  sha256 "1efeb1527bd48f8787281e8be1d0e8ff2e584d4c1994a0bc2f6859be2ffad4cf"

  bottle do
    cellar :any
    revision 1
    sha1 "ef44221e7e675704a36b0e0e8a78b350c22f67bf" => :yosemite
    sha1 "a1beaa7f9e7d1733fd0ab905c4445c30352e876d" => :mavericks
    sha1 "46e386cb03763d3de5b584afd77315ee044bcd2b" => :mountain_lion
  end

  head do
    url "https://github.com/fontforge/libspiro.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
