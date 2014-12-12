require "formula"

class LibtorrentRasterbar < Formula
  homepage "http://sourceforge.net/projects/libtorrent/"
  url "https://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-1.0.3.tar.gz"
  sha1 "ccdd8bdba178b300921b15b18dfe8c0705f7eb07"

  head do
    url "https://libtorrent.googlecode.com/svn/trunk"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "9e270e0c4c512697b0684793b2e729823da40d0f" => :yosemite
    sha1 "5af3a0855ae25f39809b3531930e6de970f54cfa" => :mavericks
    sha1 "7c0b65bc0d436396df9556916a99e40248f55ad9" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :python => :optional
  depends_on "geoip" => :optional
  depends_on "boost"
  depends_on "boost-python" if build.with? "python"

  def install
    args = [ "--disable-debug",
             "--disable-dependency-tracking",
             "--disable-silent-rules",
             "--enable-encryption",
             "--prefix=#{prefix}",
             "--with-boost=#{Formula["boost"].opt_prefix}" ]

    # Build python bindings requires forcing usage of the mt version of boost_python.
    if build.with? "python"
      args << "--enable-python-binding"
      args << "--with-boost-python=boost_python-mt"
    end

    if build.with? "geoip"
      args << "--enable-geoip"
      args << "--with-libgeoip"
    end

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end
end
