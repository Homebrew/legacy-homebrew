require 'formula'

class Stunnel < Formula
  url 'ftp://ftp.stunnel.org/stunnel/obsolete/4.x/stunnel-4.37.tar.gz'
  homepage 'http://www.stunnel.org/'
  md5 '8d4e2cefbef6638da95986a3d44c1b4a'

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
index 274f9a0..d5d7cc0 100644
--- a/tools/stunnel.cnf
+++ b/tools/stunnel.cnf
@@ -7,6 +7,7 @@ default_bits = 1024
 encrypt_key = yes
 distinguished_name = req_dn
 x509_extensions = cert_type
+prompt = no
 
 [ req_dn ]
 countryName = Country Name (2 letter code)
