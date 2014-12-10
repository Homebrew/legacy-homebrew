require "formula"

class Hercules < Formula
  homepage "http://www.hercules-390.eu/"
  url "http://downloads.hercules-390.eu/hercules-3.10.tar.gz"
  sha1 "10599041c7e5607cf2e7ecc76802f785043e2830"

  skip_clean :la

  head do
    url "https://github.com/hercules-390/hyperion.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-optimization=no"
    system "make"
    system "make", "install"
  end
end
