require "formula"

class Clamav < Formula
  homepage "http://www.clamav.net/"
  url "https://downloads.sourceforge.net/clamav/clamav-0.98.5.tar.gz"
  sha1 "5f5e45735819e3ca61610899b779172a5639f70f"

  bottle do
    sha1 "3cec3e85844d54a629a735a4cd035475af1a62b4" => :mavericks
    sha1 "2f7e1f591e956369eae6446e4a5aeb4ee79940e4" => :mountain_lion
    sha1 "07e9159ecbf0aa90dd56a7ee9d728b7bb77d5b6b" => :lion
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
