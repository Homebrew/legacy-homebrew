require 'formula'

class Redstore < Formula
  url 'http://www.aelius.com/njh/redstore/redstore-0.5.4.tar.gz'
  homepage 'http://www.aelius.com/njh/redstore/'
  md5 '5857c99d0aaf384050ea17e15354feba'

  depends_on 'pkg-config' => :build
  depends_on 'redland'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
