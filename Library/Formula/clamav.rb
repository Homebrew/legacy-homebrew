class Clamav < Formula
  desc "Anti-virus software"
  homepage "http://www.clamav.net/"
  url "https://downloads.sourceforge.net/clamav/clamav-0.98.7.tar.gz"
  sha1 "c9793d67c041e2b944116d912f8681c8bd6e4432"

  bottle do
    sha256 "3c8049f743c8968556ff116b22dfaa23e328210d66f2d53a4623ddc9d03c3b9e" => :yosemite
    sha256 "ccf874073326be643f6bc2fafcd12e2ea2cb020b633396ee9dea914e7a89f022" => :mavericks
    sha256 "accfae39dbcda36377f7a604d6c865769dd4e193238c2c71b46a07d560c72232" => :mountain_lion
  end

  head do
    url "https://github.com/vrtadmin/clamav-devel.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on "json-c" => :optional

  skip_clean "share/clamav"

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--libdir=#{lib}",
      "--sysconfdir=#{etc}/clamav",
      "--disable-zlib-vcheck",
      "--with-zlib=#{MacOS.sdk_path}/usr",
      "--with-openssl=#{Formula["openssl"].opt_prefix}",
    ]

    args << "--with-libjson=#{Formula["json-c"].opt_prefix}" if build.with? "json-c"

    (share/"clamav").mkpath
    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    To finish installation & run clamav you will need to edit
    the example conf files at #{etc}/clamav/
    EOS
  end

  test do
    system "#{bin}/clamav-config", "--version"
  end
end
