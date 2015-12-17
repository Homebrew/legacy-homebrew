class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "http://rybczak.net/ncmpcpp/"
  url "http://rybczak.net/ncmpcpp/stable/ncmpcpp-0.6.7.tar.bz2"
  sha256 "08807dc515b4e093154a6e91cdd17ba64ebedcfcd7aa34d0d6eb4d4cc28a217b"
  revision 2

  bottle do
    cellar :any
    sha256 "f3a1dff9e1e053f22799c7ecdea3997f7adabf923c9b91dde9d1f29d30720bef" => :el_capitan
    sha256 "e7597bdcc79ec3dcde075f60ebcb958e95abf09c6bc6c3fd49b539e2ad59525d" => :yosemite
    sha256 "c781cec0064aab5a050a314b1a67f5980f3879955ef3d32fbda1b0ee58676111" => :mavericks
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
    depends_on "boost" => "c++11"
    depends_on "taglib" => "c++11"
  else
    depends_on "boost"
    depends_on "taglib"
  end

  needs :cxx11

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-liconv"

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
