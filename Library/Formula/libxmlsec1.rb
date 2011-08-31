require 'formula'

class Libxmlsec1 < Formula
  url 'http://www.aleksey.com/xmlsec/download/xmlsec1-1.2.18.tar.gz'
  homepage 'http://www.aleksey.com/xmlsec/'
  md5 '8694b4609aab647186607f79e1da7f1a'

  # use the keg-only libxml2 as Snow Leopard and Lion's versions are too old
  depends_on 'libxml2'

  # use gnutls as an additional crypto engine, alongside system openssl
  depends_on 'gnutls' => :optional

  def install
    libxml2 = Formula.factory('libxml2')

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libxml=#{libxml2.prefix}"
    system "make install"
  end
end
