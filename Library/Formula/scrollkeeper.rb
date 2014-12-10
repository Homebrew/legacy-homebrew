require 'formula'

class Scrollkeeper < Formula
  homepage 'http://scrollkeeper.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/scrollkeeper/scrollkeeper/0.3.14/scrollkeeper-0.3.14.tar.gz'
  sha1 '0462799a2d96f46dec76f2fd057e2dfe8d7cb94d'

  depends_on 'gettext'
  depends_on 'docbook'

  conflicts_with 'rarian',
    :because => "scrollkeeper and rarian install the same binaries."

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make install"
  end
end
