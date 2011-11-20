require 'formula'

class Libcld < Formula
  head 'git://github.com/mzsanford/cld.git', :tag => 'v0.1.1'
  homepage 'https://github.com/mzsanford/cld'
  md5 '03ea94f74f9a01bbabbc93259c1eaac001ce7ca8'
  version '0.1.0'


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end

end

