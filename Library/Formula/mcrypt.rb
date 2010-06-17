require 'formula'

class Mcrypt <Formula
  url 'ftp://mirror.internode.on.net/pub/gentoo/distfiles/libmcrypt-2.5.8.tar.gz'
  homepage 'http://mcrypt.sourceforge.net'
  md5 '0821830d930a86a5c69110837c55b7da'

  aka 'libmcrypt'

  def install
    ENV.universal_binary if ARGV.include? "--universal"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--mandir=#{man}"
    system "make install"
  end
end
