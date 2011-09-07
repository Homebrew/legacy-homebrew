require 'formula'

class Mairix < Formula
  homepage 'http://www.rpcurnow.force9.co.uk/mairix/'
  url 'http://downloads.sourceforge.net/project/mairix/mairix/0.22/mairix-0.22.tar.gz'
  md5 '6c6aaca19c2b2de3bf567b856705ce1a' #821619895931711c370f51f3442a0ded'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
