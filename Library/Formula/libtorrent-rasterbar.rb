class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "http://sourceforge.net/projects/libtorrent/"
  url "https://downloads.sourceforge.net/project/libtorrent/libtorrent/libtorrent-rasterbar-1.0.5.tar.gz"
  sha256 "474a43da2147bec7e333c10f70b07221f4732dd67e071d5e90acc7edb8f657b0"

  head do
    url "https://libtorrent.googlecode.com/svn/trunk"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "8f298669f6a5164a24f4c57e70032be2538c002e8db6507b50e4d4c539555c28" => :yosemite
    sha256 "b5a212226c0184169e28fb5da8bdb1cf31b0e890899599ed6fbbc389e9b67c79" => :mavericks
    sha256 "362267d8573028a6407f68bd7c75c79a3af1ec5e02c7babb11a56b5948451b37" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :python => :optional
  depends_on "geoip" => :optional
  depends_on "boost"
  depends_on "boost-python" if build.with? "python"

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-encryption",
            "--prefix=#{prefix}",
            "--with-boost=#{Formula["boost"].opt_prefix}"]

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
