class Clamav < Formula
  desc "Anti-virus software"
  homepage "http://www.clamav.net/"
  url "http://www.clamav.net/downloads/production/clamav-0.99.1.tar.gz"
  sha256 "e144689122d3f91293808c82cbb06b7d3ac9eca7ae29564c5d148ffe7b25d58a"

  bottle do
    sha256 "f1febe378c19074dd99542d20156ebed49ebab91ebb5ba27d9a095f6bf9121f0" => :el_capitan
    sha256 "1b13689bef5dd5afb06da556bea1030f04c4d100bac96dfd83bde0adc135e067" => :yosemite
    sha256 "a7ca98533a103e466d3724ffe32f28f2891f0a97a1e96e644cd692f16c502590" => :mavericks
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
