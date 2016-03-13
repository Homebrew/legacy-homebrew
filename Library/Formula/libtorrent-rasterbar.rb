class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "http://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_9/libtorrent-rasterbar-1.0.9.tar.gz"
  sha256 "11a93125ed49f796fca83da925ab7dc29e91d88b915f078caaddaaf559d63db6"

  bottle do
    cellar :any
    sha256 "b3b02cf5da26bddb5876067b414c7867297c5a00225424b3ba97e8d6bca1791d" => :el_capitan
    sha256 "1b6c1f9eab95420b4a8c852ded53bb668ac110b0a713d09fb311e08204d30674" => :yosemite
    sha256 "18fe39240ec4ae6b2cbbb93369be738d0acccbe82f6e92128302a39c1a0747f1" => :mavericks
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
