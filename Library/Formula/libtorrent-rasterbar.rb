class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "http://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_8/libtorrent-rasterbar-1.0.8.tar.gz"
  sha256 "477ee10cd4a91b0a13e2ee419096555d0c75584ef1b84abc44b3b643f9a08d3e"

  bottle do
    cellar :any
    sha256 "8fc3e5d11c0e0fc6a01a9186dae919e5abcea02a94a646a6ddcb42852037efb3" => :el_capitan
    sha256 "8de980a07c3ee45de68db905a37dc8517f580b5f4c2fd6c0348a74f9d0d2a732" => :yosemite
    sha256 "81f18d18a0cb6ade03b7ab50da7c0c2ff5d1882f16ce65c20dd2d6e21b3bb40e" => :mavericks
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
