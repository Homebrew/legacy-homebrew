require "formula"

class Clamav < Formula
  homepage "http://www.clamav.net/"
  url "https://downloads.sourceforge.net/clamav/clamav-0.98.5.tar.gz"
  sha1 "5f5e45735819e3ca61610899b779172a5639f70f"

  bottle do
    sha1 "181a03aa6d5e1ebc7dd1a200a7cf0b3e574188cf" => :yosemite
    sha1 "70333337e5f516c0e7a091a458f9cb166b805239" => :mavericks
    sha1 "1e693ec6df51b2c8095feffce49850c32a409c35" => :mountain_lion
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
    args = [ "--disable-dependency-tracking",
             "--disable-silent-rules",
             "--prefix=#{prefix}",
             "--libdir=#{lib}",
             "--sysconfdir=#{etc}/clamav",
             "--disable-zlib-vcheck",
             "--with-zlib=#{MacOS.sdk_path}/usr",
             "--with-openssl=#{Formula["openssl"].opt_prefix}"
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
