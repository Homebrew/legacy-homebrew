require 'formula'

class Ncdu < Formula
  url 'http://dev.yorhel.nl/download/ncdu-1.8.tar.gz'
  homepage 'http://dev.yorhel.nl/ncdu'
  sha1 '3d98e78cf7035e32333d263d301d12e9b4352598'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
