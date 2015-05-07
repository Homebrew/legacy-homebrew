require "formula"

class Cpputest < Formula
  homepage "http://www.cpputest.org/"
  url "https://github.com/cpputest/cpputest.github.io/blob/master/releases/cpputest-3.7.1.tar.gz"
  sha1 "ecde7a517afc1ec29efa01b869f355b6da974458"

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
