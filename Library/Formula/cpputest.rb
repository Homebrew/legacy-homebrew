require "formula"

class Cpputest < Formula
  homepage "http://www.cpputest.org/"
  url "https://github.com/cpputest/cpputest/archive/3.7.2.tar.gz"
  sha1 "4b9bd6d821dd04a87744c91592411df2ea77502e"

  head do
    url "https://github.com/cpputest/cpputest.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
