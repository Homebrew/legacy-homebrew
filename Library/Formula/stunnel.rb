require "formula"

class Stunnel < Formula
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.08.tar.gz"
  mirror "http://www.usenix.org.uk/mirrors/stunnel/stunnel-5.08.tar.gz"
  sha256 "830b21d24cd237e96f4d7993be43553d4eba4d3cfa2660faa78dec8d41d314fc"

  bottle do
    sha1 "24b0625b1e8bf6dbeadd06c0356046cb6d78d953" => :yosemite
    sha1 "d7f393c179a476a71fb782920feb60161be50406" => :mavericks
    sha1 "be84862ed87f0a6e36327da9b02bb76bbc84e0ea" => :mountain_lion
  end

  depends_on "openssl"

  def install
    # This causes a bogus .pem to be created in lieu of interactive cert generation.
    stunnel_cnf = Pathname.new("tools/stunnel.cnf")
    stunnel_cnf.unlink
    stunnel_cnf.write <<-EOS.undent
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

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--disable-libwrap",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install", "cert"
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
