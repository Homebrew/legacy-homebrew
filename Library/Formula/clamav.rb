class Clamav < Formula
  desc "Anti-virus software"
  homepage "http://www.clamav.net/"
  url "https://downloads.sourceforge.net/clamav/clamav-0.98.7.tar.gz"
  sha256 "282417b707740de13cd8f18d4cbca9ddd181cf96b444db2cad98913a5153e272"
  revision 1

  bottle do
    sha256 "1407c98137cc9e4a3cf839d4a7e48349dc1fe7028e6a1f3a2bd8cee400013406" => :yosemite
    sha256 "c100729030ac052a54d2724dd8b7ebc13f5897168be2cda7a1ee03e1abb4f48c" => :mavericks
    sha256 "67dd99e5bf71766f35208aa20dcbb3bb6767d578b755d3ca95f1e7d5d5f7ddee" => :mountain_lion
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
      "--enable-llvm=no"
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
