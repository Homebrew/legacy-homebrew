require "formula"

class Ttfautohint < Formula
  homepage "http://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.2/ttfautohint-1.2.tar.gz"
  sha1 "d4c4c570139da9667744e086da57ee5a21872630"

  head do
    url "http://repo.or.cz/ttfautohint.git"
    depends_on "bison" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkg-config" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "560b377ed563e03032b8ca14a6e23cf051c9e855" => :mavericks
    sha1 "c2958652ba83dc5d2a34baebd2041b9b6832eb98" => :mountain_lion
    sha1 "747d9dec24fffae7b4c2d5a76fe69527cc5b837d" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "harfbuzz"

  def install
    if build.head?
      ln_s cached_download/".git", ".git"
      system "./bootstrap"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-qt=no",
                          "--without-doc"
    system "make install"
  end

  test do
    system "#{bin}/ttfautohint", "-V"
  end
end
