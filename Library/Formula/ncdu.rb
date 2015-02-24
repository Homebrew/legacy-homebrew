require 'formula'

class Ncdu < Formula
  homepage 'http://dev.yorhel.nl/ncdu'
  url 'http://dev.yorhel.nl/download/ncdu-1.10.tar.gz'
  sha1 'cf3b5fbb5b69cbae5425bfff2660ac3d8224a605'

  head do
    url 'git://g.blicky.net/ncdu.git'

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
