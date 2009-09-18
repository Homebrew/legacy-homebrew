require 'brewkit'

class Irssi <Formula
  @url='http://irssi.org/files/irssi-0.8.14.tar.bz2'
  @homepage='http://irssi.org/'
  @md5='00efe7638dd596d5930dfa2aeae87b3a'

  depends_on 'pkg-config'
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-modules", "--enable-ssl", "--enable-ipv6", "--with-perl=yes"
    system "make install"
  end
end
