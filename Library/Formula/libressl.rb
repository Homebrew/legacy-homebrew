class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.3.2.tar.gz"
  sha256 "80f45fae4859f161b1980cad846d4217417d0c89006ad29c0ea8c88da564a96a"

  bottle do
    sha256 "90888d5260e513959b37d277f9bdc26b8905dd9461ba3adec42c5f766cb26a1b" => :el_capitan
    sha256 "ae2b74d0aec28cdeb2aefb2455f5ac5f0083554a835830d563665fa6c5ab6713" => :yosemite
    sha256 "a803688c1c8fb3ce0a9eeb98e8be99c44f1b97b5244cd6b8dcbc1b86ac9f983e" => :mavericks
  end

  head do
    url "https://github.com/libressl-portable/portable.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  keg_only "LibreSSL is not linked to prevent conflict with the system OpenSSL."

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssldir=#{etc}/libressl
      --sysconfdir=#{etc}/libressl
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
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

    # LibreSSL install a default pem - We prefer to use OS X for consistency.
    rm_f etc/"libressl/cert.pem"
    (etc/"libressl/cert.pem").atomic_write(valid_certs.join("\n"))
  end

  def caveats; <<-EOS.undent
    A CA file has been bootstrapped using certificates from the system
    keychain. To add additional certificates, place .pem files in
      #{etc}/libressl/certs

    and run
      #{opt_bin}/openssl certhash #{etc}/libressl/certs
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise LibreSSL gets moody.
    assert (HOMEBREW_PREFIX/"etc/libressl/openssl.cnf").exist?,
            "LibreSSL requires the .cnf file for some functionality"

    # Check LibreSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system "#{bin}/openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
