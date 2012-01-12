require 'formula'

class Openldap < Formula
  url 'ftp://ftp.OpenLDAP.org/pub/OpenLDAP/openldap-release/openldap-2.4.28.tgz'
  homepage 'http://www.openldap.org/'
  md5 '196023e552eeb259e048edcd61a9645b'

  depends_on 'berkeley-db'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make depend"
    system "make install"
  end

  def test
    system "ldapwhoami -VV"
  end
end
