class Clamav < Formula
  desc "Anti-virus software"
  homepage "http://www.clamav.net/"
  url "http://www.clamav.net/downloads/production/clamav-0.99.1.tar.gz"
  sha256 "e144689122d3f91293808c82cbb06b7d3ac9eca7ae29564c5d148ffe7b25d58a"

  bottle do
    sha256 "713358af050acfb211bfed879f8b49ab310ff51b8ca92a446ff6e9a562c8c1e6" => :el_capitan
    sha256 "ea7d6586027e16fdf4587a9aadf144d992c9e92951078fcec8d303763bdea796" => :yosemite
    sha256 "b9829244db5aa864d82d2d1c4f8f26aa23887a26659bc6babd74a8dded4c6061" => :mavericks
  end

  head do
    url "https://github.com/vrtadmin/clamav-devel.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "yara" => :optional
  depends_on "json-c" => :optional
  depends_on "pcre" => :optional

  skip_clean "share/clamav"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --libdir=#{lib}
      --sysconfdir=#{etc}/clamav
      --disable-zlib-vcheck
      --with-zlib=#{MacOS.sdk_path}/usr
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --enable-llvm=no
    ]

    args << "--with-libjson=#{Formula["json-c"].opt_prefix}" if build.with? "json-c"
    args << "--with-pcre=#{Formula["pcre"].opt_prefix}" if build.with? "pcre"
    args << "--disable-yara" if build.without? "yara"
    args << "--without-pcre" if build.without? "pcre"

    pkgshare.mkpath
    system "autoreconf", "-fvi" if build.head?
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
