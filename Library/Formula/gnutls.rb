class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "http://gnutls.org/"
  url "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-3.4.9.tar.xz"
  mirror "https://gnupg.org/ftp/gcrypt/gnutls/v3.4/gnutls-3.4.9.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.4/gnutls-3.4.9.tar.xz"
  sha256 "48594fadba33d450f796ec69526cf2bce6ff9bc3dc90fbd7bf38dc3601f57c3f"

  bottle do
    cellar :any
    sha256 "201b23f732436c3a1ac4f5458b9a3f8c38fcb5128f360a0b831bfd4d818e10f2" => :el_capitan
    sha256 "0c45fab6d5f18725d23470d6ab4d687edbbcfd7a9b1b35c6359184ee23b12596" => :yosemite
    sha256 "4819bddf4ec41894d8ebab2c725762b0b2cf46ad3750661cdcd5e7ba1e9a539a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "gmp"
  depends_on "nettle"
  depends_on "guile" => :optional
  depends_on "unbound" => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{etc}/openssl/cert.pem
      --disable-heartbeat-support
      --without-p11-kit
    ]

    if build.with? "guile"
      args << "--enable-guile"
      args << "--with-guile-site-dir=no"
    end

    system "./configure", *args
    system "make", "install"

    # certtool shadows the OS X certtool utility
    mv bin/"certtool", bin/"gnutls-certtool"
    mv man1/"certtool.1", man1/"gnutls-certtool.1"
  end

  def post_install
    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certs_list = `security find-certificate -a -p #{keychains.join(" ")}`
    certs = certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m
    )

    valid_certs = certs.select do |cert|
      IO.popen("openssl x509 -inform pem -checkend 0 -noout", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $?.success?
    end

    openssldir = etc/"openssl"
    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n"))
  end

  test do
    system bin/"gnutls-cli", "--version"
  end
end
