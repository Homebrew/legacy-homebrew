class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "http://sourceforge.net/projects/libtorrent/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_6/libtorrent-rasterbar-1.0.6.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libt/libtorrent-rasterbar/libtorrent-rasterbar_1.0.6.orig.tar.gz"
  sha256 "c97de804b77f44591801631aca3869567671df2d3e2afe7f5453d8db2478fd61"

  bottle do
    cellar :any
    sha256 "8f298669f6a5164a24f4c57e70032be2538c002e8db6507b50e4d4c539555c28" => :yosemite
    sha256 "b5a212226c0184169e28fb5da8bdb1cf31b0e890899599ed6fbbc389e9b67c79" => :mavericks
    sha256 "362267d8573028a6407f68bd7c75c79a3af1ec5e02c7babb11a56b5948451b37" => :mountain_lion
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
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
    libexec.install "examples"
  end

  test do
    system ENV.cxx, "-L#{lib}", "-ltorrent-rasterbar",
           "-I#{Formula["boost"].include}/boost",
           "-L#{Formula["boost"].lib}/boost/bind", "-lboost_system",
           libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    File.exist? testpath/"test.torrent"
  end
end
