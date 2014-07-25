require 'formula'

class Stunnel < Formula
  homepage 'http://www.stunnel.org/'
  url 'ftp://ftp.nluug.nl/pub/networking/stunnel/stunnel-5.02.tar.gz'
  mirror 'https://www.stunnel.org/downloads/stunnel-5.02.tar.gz'
  sha256 'c258b71d7f82bba5b0a4ccc69fbda632f1fefe9108589a92aa1016f33985973e'

  depends_on "openssl"

  def install
    # This causes a bogus .pem to be created in lieu of interactive cert generation.
    File.open('tools/stunnel.cnf', 'w') do |f|
      f.write <<-EOS
# OpenSSL configuration file to create a server certificate
# by Michal Trojnara 1998-2013

[ req ]
# the default key length is secure and quite fast - do not change it
default_bits                    = 2048
# comment out the next line to protect the private key with a passphrase
encrypt_key                     = no
distinguished_name              = req_dn
x509_extensions                 = cert_type
prompt                          = no

[ req_dn ]
countryName                     = PL
stateOrProvinceName             = Mazovia Province
localityName                    = Warsaw
organizationName                = Stunnel Developers
organizationalUnitName          = Provisional CA
0.commonName                    = localhost

# To create a certificate for more than one name uncomment:
# 1.commonName                  = DNS alias of your server
# 2.commonName                  = DNS alias of your server
# ...
# See http://home.netscape.com/eng/security/ssl_2.0_certificate.html
# to see how Netscape understands commonName.

[ cert_type ]
nsCertType                      = server
      EOS
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--disable-libwrap",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      A bogus SSL server certificate has been installed to:
        #{etc}/stunnel/stunnel.pem

      This certificate will be used by default unless a config file says otherwise!

      In your stunnel configuration, specify a SSL certificate with
      the "cert =" option for each service.
    EOS
  end
end
