require "formula"

class Libressl < Formula
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.1.2.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/LibreSSL/libressl-2.1.2.tar.gz"
  sha256 "07c05f12e5d49dbfcf82dd23b6b4877b7cdb1c8e4c8dd27cb4d9e5758a6caf52"

  option "without-libtls", "Build without libtls"

  bottle do
    sha1 "fca5d55a55ea69eea9bd462d788f9157ba68853b" => :yosemite
    sha1 "b8ba84dd423acb17976a17437c91ed33d59636f0" => :mavericks
    sha1 "dd58fa644e7fc23a7883696372174fbfa1451930" => :mountain_lion
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
    system "#{bin}/openssl", "dgst", "-sha1", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
