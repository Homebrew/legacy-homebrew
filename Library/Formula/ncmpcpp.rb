class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "http://ncmpcpp.rybczak.net/"
  url "http://ncmpcpp.rybczak.net/stable/ncmpcpp-0.6.7.tar.bz2"
  sha256 "08807dc515b4e093154a6e91cdd17ba64ebedcfcd7aa34d0d6eb4d4cc28a217b"

  bottle do
    cellar :any
    sha256 "72cb60d16336585f1f75462fd96712aee088aa9c927ce0bf873a202e78dc5307" => :el_capitan
    sha256 "ef74125f6a199f229f26ad4b3e3d095367bd35daff220c99f4bb78c00e7b5221" => :yosemite
    sha256 "6a6f27e66b8ddc8dca51515032d9a36d8c660910ac3815aa16b960e9d747acb4" => :mavericks
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

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
    depends_on "taglib" => "c++11"
  else
    depends_on "boost"
    depends_on "taglib"
  end

  depends_on "fftw" if build.with? "visualizer"

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
end
