require 'formula'

class Stunnel < Formula
  url 'ftp://ftp.stunnel.org/stunnel/stunnel-4.45.tar.gz'
  homepage 'http://www.stunnel.org/'
  sha256 'cbce8279c1ba7a07bfefeb2e477f682bfd326519f8a7ed296e35210599898a2d'

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
index 0c00347..f53668f 100644
--- a/tools/stunnel.cnf
+++ b/tools/stunnel.cnf
@@ -5,6 +5,7 @@ default_bits                    = 2048
 encrypt_key                     = no
 distinguished_name              = req_dn
 x509_extensions                 = cert_type
+prompt                          = no

 [ req_dn ]
 countryName = Country Name (2 letter code)
