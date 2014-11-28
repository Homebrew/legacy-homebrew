require "formula"

class Libressl < Formula
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.1.1.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/LibreSSL/libressl-2.1.1.tar.gz"
  sha256 "fb5ada41a75b31c8dd9ff013daca57b253047ad14e43f65d8b41879b7b8e3c17"

  bottle do
    revision 2
    sha1 "a98059642ac02c864875c002a78a7dbae0fc783a" => :yosemite
    sha1 "f24b31201a7d85ae8b8b722e19224205daeda6c1" => :mavericks
    sha1 "c26900c1475e0c840c7a11801a01098dd0ce65be" => :mountain_lion
  end

  head do
    url "https://github.com/libressl-portable/portable.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  keg_only "LibreSSL is not linked to prevent conflicts with the system OpenSSL."

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssldir=#{etc}/libressl",
                          "--sysconfdir=#{etc}/libressl",
                          "--with-enginesdir=#{lib}/engines"

    system "make"
    system "make", "check"
    system "make", "install"

    mkdir_p "#{etc}/libressl"
    touch "#{etc}/libressl/openssl.cnf"
  end

  def post_install
    if (etc/"openssl/cert.pem").exist?
      cp "#{etc}/openssl/cert.pem", "#{etc}/libressl"
    else
      touch "#{etc}/libressl/cert.pem"
    end
  end

  def caveats; <<-EOS.undent
    If you have OpenSSL installed, the .pem file has been copied
    from there. Otherwise, a blank .pem file has been touched.
    To add additional certificates, place .pem files in
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
