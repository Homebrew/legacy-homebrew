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
    cellar :any
    sha256 "52f49857c787553ccd3439aeeba3988066bcabc4244d0a40a8220cc4e368d3e7" => :yosemite
    sha256 "97e8fc6f9b4eaf89f1dd4988e7bf3d3c86f7a096c27b2cec7ef7460b43009153" => :mavericks
    sha256 "c094fd6b5826e83b99ee71be5f075d2a44c81e33a2c6a480b5709ad696825aa2" => :mountain_lion
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
