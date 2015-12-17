class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "http://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_7/libtorrent-rasterbar-1.0.7.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libt/libtorrent-rasterbar/libtorrent-rasterbar_1.0.7.orig.tar.gz"
  sha256 "3e16e024b175fefada17471c659fdbcfab235f9619d4f0913faa13cb02ca8d83"

  bottle do
    cellar :any
    sha256 "6de67c9d1e3748bd3a00cd6907c39a713596da7588e94093914c516ee3beeb3d" => :el_capitan
    sha256 "18fd7bf5de587f7ed1c2ed4c2bfe58061b0f12537a5b03ffed8db590bde72d1e" => :yosemite
    sha256 "c41f4f35b5a923129c238f6e2df3dead0304cd4006ae8076967ccbe2ea3cfc37" => :mavericks
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
           "-I#{Formula["boost"].include}/boost", "-lboost_system",
           libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    File.exist? testpath/"test.torrent"
  end
end
