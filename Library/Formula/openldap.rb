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

  def caveats; <<-EOS.undent
    OpenLDAP depends on berkeley-db 4.x, but Homebrew provides version 5.x,
    which doesn't work. To work around this, do:
      $ brew install https://github.com/adamv/homebrew/raw/versions/Library/Formula/berkeley-db4.rb --without-java
      $ brew install --ignore-dependencies openldap
    EOS
  end
end
