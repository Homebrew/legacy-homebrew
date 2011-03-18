require 'formula'

class Ldapvi < Formula
  url 'http://www.lichteblau.com/download/ldapvi-1.7.tar.gz'
  homepage 'http://www.lichteblau.com/ldapvi/'
  md5 '6dc2f5441ac5f1e2b5b036e3521012cc'

  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'popt'
  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
