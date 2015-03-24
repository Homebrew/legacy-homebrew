require "formula"

class LibtorrentRasterbar < Formula
  homepage "http://sourceforge.net/projects/libtorrent/"
  url "https://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-1.0.4.tar.gz"
  sha256 "1f567823133b1493b9717afc8334eed691bf0ab452d4a2e0f644989f13ce9db0"

  head do
    url "https://libtorrent.googlecode.com/svn/trunk"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
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
