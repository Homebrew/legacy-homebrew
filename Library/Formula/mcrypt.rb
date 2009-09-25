require 'brewkit'

class Mcrypt <Formula
  @url='ftp://mirror.internode.on.net/pub/gentoo/distfiles/libmcrypt-2.5.8.tar.gz'
  @homepage='http://mcrypt.sourceforge.net'
  @md5='0821830d930a86a5c69110837c55b7da'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
