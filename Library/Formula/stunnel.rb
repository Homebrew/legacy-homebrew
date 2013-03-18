require 'formula'

class Stunnel < Formula
  homepage 'http://www.stunnel.org/'
  url 'ftp://ftp.stunnel.org/stunnel/archive/4.x/stunnel-4.55.tar.gz'
  mirror 'http://ftp.nluug.nl/pub/networking/stunnel/stunnel-4.55.tar.gz'
  sha1 '9d29eb2f1880c7cf9ecbbd96dee8c0f8cc7e7f88'

  # This patch installs a bogus .pem in lieu of interactive cert generation.
  # - additionally stripping carriage-returns
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-libwrap",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
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


__END__
diff --git a/tools/stunnel.cnf b/tools/stunnel.cnf
index d8c3174..5ad26e0 100644
--- a/tools/stunnel.cnf
+++ b/tools/stunnel.cnf
@@ -1,42 +1,30 @@
-# OpenSSL configuration file to create a server certificate
-# by Michal Trojnara 1998-2012
-
-[ req ]
-# the default key length is secure and quite fast - do not change it
-default_bits                    = 2048
-# comment out the next line to protect the private key with a passphrase
-encrypt_key                     = no
-distinguished_name              = req_dn
-x509_extensions                 = cert_type
-
-[ req_dn ]
-countryName = Country Name (2 letter code)
-countryName_default             = PL
-countryName_min                 = 2
-countryName_max                 = 2
-
-stateOrProvinceName             = State or Province Name (full name)
-stateOrProvinceName_default     = Mazovia Province
-
-localityName                    = Locality Name (eg, city)
-localityName_default            = Warsaw
-
-organizationName                = Organization Name (eg, company)
-organizationName_default        = Stunnel Developers
-
-organizationalUnitName          = Organizational Unit Name (eg, section)
-organizationalUnitName_default  = Provisional CA
-
-0.commonName                    = Common Name (FQDN of your server)
-0.commonName_default            = localhost
-
-# To create a certificate for more than one name uncomment:
-# 1.commonName                  = DNS alias of your server
-# 2.commonName                  = DNS alias of your server
-# ...
-# See http://home.netscape.com/eng/security/ssl_2.0_certificate.html
-# to see how Netscape understands commonName.
-
-[ cert_type ]
-nsCertType                      = server
-
+# OpenSSL configuration file to create a server certificate
+# by Michal Trojnara 1998-2012
+
+[ req ]
+# the default key length is secure and quite fast - do not change it
+default_bits                    = 2048
+# comment out the next line to protect the private key with a passphrase
+encrypt_key                     = no
+distinguished_name              = req_dn
+x509_extensions                 = cert_type
+prompt                          = no
+
+[ req_dn ]
+countryName                     = PL
+stateOrProvinceName             = Mazovia Province
+localityName                    = Warsaw
+organizationName                = Stunnel Developers
+organizationalUnitName          = Provisional CA
+0.commonName                    = localhost
+
+# To create a certificate for more than one name uncomment:
+# 1.commonName                  = DNS alias of your server
+# 2.commonName                  = DNS alias of your server
+# ...
+# See http://home.netscape.com/eng/security/ssl_2.0_certificate.html
+# to see how Netscape understands commonName.
+
+[ cert_type ]
+nsCertType                      = server
+
--
1.7.9
