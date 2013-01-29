require 'formula'

class Ncdu < Formula
  homepage 'http://dev.yorhel.nl/ncdu'
  url 'http://dev.yorhel.nl/download/ncdu-1.8.tar.gz'
  sha1 '3d98e78cf7035e32333d263d301d12e9b4352598'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
