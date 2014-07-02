require "formula"

class LibtorrentRasterbar < Formula
  homepage "http://www.rasterbar.com/products/libtorrent/"
  url "https://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-1.0.0.tar.gz"
  sha1 "d7ea9ae8d89c2673c6bd16b3b3d4ef00fc5857e0"

  head do
    url "https://libtorrent.googlecode.com/svn/trunk"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "0a1b9a57a66f2f38c125e21f1b1e1f5eeaa1aab3" => :mavericks
    sha1 "432ae45679555de8dd26d136cf84eb16c88d0b1d" => :mountain_lion
    sha1 "f59cc0d4a7ce1cfdfe221039cfe76958564e834b" => :lion
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
