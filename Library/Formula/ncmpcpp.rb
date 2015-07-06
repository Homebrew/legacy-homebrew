class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "http://ncmpcpp.rybczak.net/"
  url "http://ncmpcpp.rybczak.net/stable/ncmpcpp-0.6.5.tar.bz2"
  sha256 "51128f6835c592c8d4367a66b08e06a9419a86c9d5c6e91d0f1dc73af56cd1fd"

  bottle do
    cellar :any
    sha256 "eeebc0e54750327c801476979ebd04c68294010f5ae6c75516a5cf96041b1072" => :yosemite
    sha256 "b05ea9ce4622731d3bade13b7e2bee7744c9ef848edc069b2da3be944577aeb1" => :mavericks
    sha256 "1a73a56715ac4633a73a848445049a3222d8dbf676e58126326ac51e11910ce5" => :mountain_lion
  end

  head do
    url "git://repo.or.cz/ncmpcpp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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

  depends_on "fftw" if build.include? "visualizer"

  option "outputs", "Compile with mpd outputs control"
  option "visualizer", "Compile with built-in visualizer"
  option "clock", "Compile with optional clock tab"

  needs :cxx11

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-liconv"

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-taglib",
            "--with-curl",
            "--enable-unicode"]

    args << "--enable-outputs" if build.include? "outputs"
    args << "--enable-visualizer" if build.include? "visualizer"
    args << "--enable-clock" if build.include? "clock"

    if build.head?
      # Also runs configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end
end
