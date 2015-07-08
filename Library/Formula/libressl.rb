class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.2.1.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/LibreSSL/libressl-2.2.1.tar.gz"
  sha256 "4f331750abfc3b605b02eeca1e8994fa0d2629985bc3f62924378197fbfe572d"

  bottle do
    sha256 "96d88a9de52cd8bc8b44c351f98a40360ded9a9d3788474a06b024201cc3f638" => :yosemite
    sha256 "42edf353873147a1f37058dd6440cf3c65748468683663619b7c163c95d5288e" => :mavericks
    sha256 "e1b78e175917e469b3ac9e6af957f913bf2dac9fb5913ebb7896f9d5253797a7" => :mountain_lion
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
