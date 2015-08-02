class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.2.1.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/LibreSSL/libressl-2.2.1.tar.gz"
  sha256 "4f331750abfc3b605b02eeca1e8994fa0d2629985bc3f62924378197fbfe572d"

  bottle do
    cellar :any
    sha256 "a63cccf5f58e5650a343113db88cdb4944cecca13a9ce3b99bf95ccc8142e102" => :yosemite
    sha256 "fd66ef44264b2ee11f94e490c349a006a25146ff3d03c9db18f742c5ac296194" => :mavericks
    sha256 "20cde578b278ea0e6ec6a757c19af8d109830ce6a852150ec93eaea994ba776c" => :mountain_lion
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
      --with-enginesdir=#{lib}/engines
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Install the dummy openssl.cnf file to stop runtime warnings.
    (etc/"libressl/certs").mkpath
    (etc/"libressl").install "apps/openssl.cnf"
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
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32"
    system bin/"openssl", "dgst", "-sha1", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
