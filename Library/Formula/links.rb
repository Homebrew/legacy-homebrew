require 'formula'

class Links < Formula
  url 'http://links.twibright.com/download/links-2.7.tar.gz'
  homepage 'http://links.twibright.com/'
  md5 '6b5ca02e180aed2f78ca2712f85e3ba5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
