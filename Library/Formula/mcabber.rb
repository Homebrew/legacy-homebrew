require 'formula'

class Mcabber <Formula
  url 'http://mcabber.com/files/mcabber-0.9.10.tar.bz2'
  homepage 'http://mcabber.com/'
  md5 '887415d16c32af58eab2ec2d9bb17fa6'

  depends_on 'glib'
  depends_on 'gpgme' => :optional
  depends_on 'aspell' => :optional
  depends_on 'enchant' => :optional
  depends_on 'libotr' => :optional
  depends_on 'libgcrypt' => :optional

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-aspell",
                          "--enable-enchant",
                          "--enable-otr",
                          "--with-ssl"
    system "make install"
  end
end
