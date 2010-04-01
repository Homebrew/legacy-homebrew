require 'formula'

class Openldap <Formula
  url 'ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.21.tgz'
  homepage 'http://www.openldap.org/software/'
  md5 'e7128c57b2bacd940e8906057c94ff26'

 depends_on 'berkeley-db'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
