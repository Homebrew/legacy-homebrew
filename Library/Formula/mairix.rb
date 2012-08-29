require 'formula'

class Mairix < Formula
  homepage 'http://www.rpcurnow.force9.co.uk/mairix/'
  url 'http://downloads.sourceforge.net/project/mairix/mairix/0.23/mairix-0.23.tar.gz'
  md5 '732cf94e05c779ff1ce4a9e9eb19ab44'

  head 'https://github.com/rc0/mairix.git'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
