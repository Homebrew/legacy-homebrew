require "formula"

class LibtorrentRasterbar < Formula
  homepage "http://www.rasterbar.com/products/libtorrent/"
  url "https://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-1.0.1.tar.gz"
  sha1 "98f0117bb716cc6210d5698068aa491bc0ac8ad0"
  revision 1

  head do
    url "https://libtorrent.googlecode.com/svn/trunk"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "2323def5cb83b4fb85108f0474bc80889b452bc4" => :mavericks
    sha1 "525fd4237cf8ddedc18d8be3fd6a1159984eef6d" => :mountain_lion
    sha1 "1b75d88d533c5f2be298df7232051f027184ec08" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :python => :optional
  depends_on "geoip" => :optional

  if build.with? "python"
    depends_on "boost" => "with-python"
  else
    depends_on "boost"
  end

  def install
    boost = Formula["boost"]

    args = [ "--disable-debug",
             "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--with-boost=#{boost.opt_prefix}" ]

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

    system "make install"
  end
end
