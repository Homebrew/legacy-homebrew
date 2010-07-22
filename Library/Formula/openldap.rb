require 'formula'

class Openldap <Formula
  url 'ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.23.tgz'
  homepage 'http://www.openldap.org/software/'
  md5 '90150b8c0d0192e10b30157e68844ddf'

 depends_on 'berkeley-db'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
