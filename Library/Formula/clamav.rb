class Clamav < Formula
  desc "Anti-virus software"
  homepage "http://www.clamav.net/"
  url "https://downloads.sourceforge.net/clamav/clamav-0.98.7.tar.gz"
  sha1 "c9793d67c041e2b944116d912f8681c8bd6e4432"

  bottle do
    sha1 "b98d88af709fc48b4cad3e07e8bf2b243a64e36b" => :yosemite
    sha1 "857c84af44eeeb1f8413f5034ff47be8f950075d" => :mavericks
    sha1 "e0b8f89118ff2c0fe2d8bca37572f4b37d327ce6" => :mountain_lion
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
