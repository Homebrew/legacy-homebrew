class Libressl < Formula
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.1.5.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/LibreSSL/libressl-2.1.5.tar.gz"
  sha256 "a82379913fd7f4e26e045fcf021aa92a1f683954816bf817b3b696de62e9c3bb"

  option "without-libtls", "Build without libtls"

  bottle do
    sha256 "b1f42ad3d599729c6f942893ef59e1860cc848557e6ea1ab7ff4b70ff626d3fe" => :yosemite
    sha256 "422accbd789a18434e01b4df5815de97316d43739e36dafd4cef41559eb85e4d" => :mavericks
    sha256 "3f530e5898c6eb1657a24a7025f3b6df9725e0e4f1ce3f28d2151d1f6d7efe23" => :mountain_lion
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

    args << "--enable-libtls" if build.with? "libtls"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Install the dummy openssl.cnf file to stop runtime warnings.
    mkdir_p "#{etc}/libressl"
    cp "apps/openssl.cnf", "#{etc}/libressl"
  end

  def post_install
    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    # Bootstrap CAs from the system keychain.
    (etc/"libressl/cert.pem").atomic_write `security find-certificate -a -p #{keychains.join(" ")}`
  end

  def caveats; <<-EOS.undent
    A CA file has been bootstrapped using certificates from the system
    keychain. To add additional certificates, place .pem files in
      #{etc}/libressl
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
