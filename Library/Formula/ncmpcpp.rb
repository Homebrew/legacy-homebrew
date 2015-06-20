class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "http://ncmpcpp.rybczak.net/"
  url "http://ncmpcpp.rybczak.net/stable/ncmpcpp-0.6.4.tar.bz2"
  sha256 "757e2e06b7e17009c24e2b46a69f008e61aa679476f93e00dc602ca087c805f1"

  bottle do
    cellar :any
    sha256 "148c59b8ffad2f92fa878c98eee982d85b8e84b48bf8d780ef89d34e96f21ad8" => :yosemite
    sha256 "a8ac370b760e9de5ce56685d231ea668d61f0953e83205385c608cc3fc3c25a6" => :mavericks
    sha256 "86743cf381d5d5b7cf1ba91b6bf6d46c7e54fa105d12d78a4f656092238fac4c" => :mountain_lion
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
