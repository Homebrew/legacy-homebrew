class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "http://rybczak.net/ncmpcpp/"
  url "http://rybczak.net/ncmpcpp/stable/ncmpcpp-0.7.3.tar.bz2"
  sha256 "2c8b29435ca4fd845400cee7c9fd50a731bee215e92fd7e98a7446c84136b212"

  bottle do
    cellar :any
    sha256 "39665b843ca20d18a587dc7fdfce58be49891d659d3c2321245f97496be53c40" => :el_capitan
    sha256 "fe37b6c0ecce4bda5dc334d18cdf50feebec058243ad169425cf68d4113d2342" => :yosemite
    sha256 "4ddc2ca6db56b7fa86c5d80c7236dccc26b5f79efb785a46a8974cc92e69a4cb" => :mavericks
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
