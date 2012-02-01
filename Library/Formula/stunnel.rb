require 'formula'

class Stunnel < Formula
  url 'ftp://ftp.stunnel.org/stunnel/archive/4.x/stunnel-4.50.tar.gz'
  homepage 'http://www.stunnel.org/'
  md5 'd68b4565294496a8bdf23c728a679f53'

  # This patch installs a bogus .pem in lieu of interactive cert generation.
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-libwrap",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
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
index 0c00347..d011421 100644
--- a/tools/stunnel.cnf
+++ b/tools/stunnel.cnf
@@ -5,27 +5,15 @@ default_bits                    = 2048
 encrypt_key                     = no
 distinguished_name              = req_dn
 x509_extensions                 = cert_type
+prompt                          = no

 [ req_dn ]
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
+countryName                     = PL
+stateOrProvinceName              = Mazovia Province
+localityName                     = Warsaw
+organizationName                 = Stunnel Developers
+organizationalUnitName           = Provisional CA
+0.commonName                     = localhost

 # To create a certificate for more than one name uncomment:
 # 1.commonName                  = DNS alias of your server
