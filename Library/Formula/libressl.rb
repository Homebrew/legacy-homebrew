class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "http://www.libressl.org/"
  revision 1

  stable do
    url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.3.0.tar.gz"
    sha256 "0451498d999ccff475226f5cfae07a3754a7b28c507c6bda007e316fc90d92a0"

    # Fixes buffer overrun and memory leak. Combination of:
    # https://github.com/libressl-portable/openbsd/commit/ea13bdff130
    # https://github.com/libressl-portable/openbsd/commit/67bf52a96ba
    # https://github.com/libressl-portable/openbsd/commit/f292734cabf
    # Fixed in 2.2.4 but no 2.3.1 release yet.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/4d256375/libressl/libressl-2.3.0-qualys-vun-fix.diff"
      sha256 "a8d8f2b763ee363d87bb06aa2f8da66b484a23907217265cc7faef85355b561f"
    end
  end

  bottle do
    sha256 "05243a223120c6b93ce30fb319ee4d4aa3fa21a8d31ec4d26d3c1e7263ced9d2" => :el_capitan
    sha256 "51160a75a5b4d88d6f4c2de46a9618b5617ff890ac6bd107ab54ad9f5a10fa76" => :yosemite
    sha256 "73c679e7e48fe3234b368621ede186dc23a16657edf1b8957f95d66c750788d7" => :mavericks
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
