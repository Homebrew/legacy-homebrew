class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "http://rybczak.net/ncmpcpp/"
  url "http://rybczak.net/ncmpcpp/stable/ncmpcpp-0.7.1.tar.bz2"
  sha256 "73b76ca9a7b08b220c49251195b9a929768759bd03cf6956b74a2f218b2e2fdf"

  bottle do
    cellar :any
    sha256 "1e893ddcf65e3982d726960d98b87c84f175830d15ee6613600cf238d938bd03" => :el_capitan
    sha256 "b1a16416a352a76ddf5ecab88b3fe48bc4c25dcd9d6f1c4fc32e6689e826d264" => :yosemite
    sha256 "68a25530d82af8e2ebdb602b9a7409a3049f967f8864960f18f113ebee241479" => :mavericks
  end

  head do
    url "git://repo.or.cz/ncmpcpp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "outputs" => "with-outputs"
  deprecated_option "visualizer" => "with-visualizer"
  deprecated_option "clock" => "with-clock"

  option "with-outputs", "Compile with mpd outputs control"
  option "with-visualizer", "Compile with built-in visualizer"
  option "with-clock", "Compile with optional clock tab"

  depends_on "pkg-config" => :build
  depends_on "libmpdclient"
  depends_on "readline"
  depends_on "fftw" if build.with? "visualizer"

  if MacOS.version < :mavericks
    depends_on "boost" => ["with-icu4c", "c++11"]
    depends_on "taglib" => "c++11"
  else
    depends_on "boost" => ["with-icu4c"]
    depends_on "taglib"
  end

  needs :cxx11

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-liconv"
    ENV.append "BOOST_LIB_SUFFIX", "-mt"
    ENV.append "CXXFLAGS", "-D_XOPEN_SOURCE_EXTENDED"

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-taglib",
      "--with-curl",
      "--enable-unicode",
    ]

    args << "--enable-outputs" if build.with? "outputs"
    args << "--enable-visualizer" if build.with? "visualizer"
    args << "--enable-clock" if build.with? "clock"

    if build.head?
      # Also runs configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncmpcpp --version")
  end
end
