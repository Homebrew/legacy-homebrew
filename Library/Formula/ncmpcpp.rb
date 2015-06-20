class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "http://ncmpcpp.rybczak.net/"
  url "http://ncmpcpp.rybczak.net/stable/ncmpcpp-0.6.4.tar.bz2"
  sha256 "757e2e06b7e17009c24e2b46a69f008e61aa679476f93e00dc602ca087c805f1"

  bottle do
    cellar :any
    sha1 "d83fa7fec86b69363f352f7b88d5ae26b90a6bdc" => :yosemite
    sha1 "efd63c4b5afec557ec43202a545ab03bbf6ac488" => :mavericks
    sha1 "8223ccaed03a7f77b7f287e49c8ea4eb1584e1d9" => :mountain_lion
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
