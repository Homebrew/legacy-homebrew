require 'formula'

class Mairix < Formula
  homepage 'http://www.rpcurnow.force9.co.uk/mairix/'
  url 'https://downloads.sourceforge.net/project/mairix/mairix/0.23/mairix-0.23.tar.gz'
  sha1 '1621d60db5fb76453e48b98d12ca86b4a68ea1de'

  head 'https://github.com/rc0/mairix.git'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
