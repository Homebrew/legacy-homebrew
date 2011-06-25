require 'formula'

class Cclive < Formula
  url 'http://cclive.googlecode.com/files/cclive-0.6.5.tar.bz2'
  homepage 'http://code.google.com/p/cclive/'
  md5 'c3d50c05ca332b01286f9f3b6dd21841'

  depends_on 'pkg-config' => :build
  depends_on 'quvi'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
