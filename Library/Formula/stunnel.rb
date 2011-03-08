require 'formula'

class Stunnel <Formula
  url 'ftp://ftp.stunnel.org/stunnel/stunnel-4.35.tar.gz'
  homepage 'http://www.stunnel.org/'
  md5 '2c8e153caee9d954fb7d00980968b50d'

  def options
    [[ '--enable-x-forwarded-proto', 'Enables appending an X-Forwarded-Proto HTTP header to notify downstream servers the request is using ssl' ]]
  end

  def patches
    # This patch installs a bogus .pem in lieu of interactive cert generation
    patches = [ DATA ]

    # This patch enables the X-FORWARDED-PROTO HTTP header
    patches << 'https://github.com/outerim/stunnel/commit/645c53a1324caed7493629d2303ed0a115d80bb0.patch' if ARGV.include? '--enable-x-forwarded-proto'

    patches
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

      This certificate will be used by default unless a config file says
      otherwise!

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
