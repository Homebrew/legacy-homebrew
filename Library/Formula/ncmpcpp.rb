class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "http://rybczak.net/ncmpcpp/"
  url "http://rybczak.net/ncmpcpp/stable/ncmpcpp-0.7.3.tar.bz2"
  sha256 "2c8b29435ca4fd845400cee7c9fd50a731bee215e92fd7e98a7446c84136b212"

  bottle do
    cellar :any
    sha256 "1082eaddb0c56271b4a4bf0ccb68be466f15ec2846911b0424d391ebf19deef1" => :el_capitan
    sha256 "5f9826f910a38feb8750e5edca2b8d7cf3990ee7d9c9751c6e4bdac2db99cb7d" => :yosemite
    sha256 "ba81b9acf4813c5458cccbd2948dfe02bb833901a44e1175935adf7def914b44" => :mavericks
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
