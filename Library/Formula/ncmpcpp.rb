require 'formula'

class Ncmpcpp < Formula
  homepage 'http://ncmpcpp.rybczak.net/'
  url 'http://ncmpcpp.rybczak.net/stable/ncmpcpp-0.6.tar.bz2'
  sha1 '7bbd63c6f17aa8cdf1190b19e2dc893df188da1c'

  bottle do
    cellar :any
    sha1 "57802cfa62bbc99594b534068e987f7fcd9e1fbb" => :yosemite
    sha1 "a39ff22a16fd90180e3d411d533738c8f640f844" => :mavericks
    sha1 "255cd14d8f3470446be1b11843de8ec331f3823e" => :mountain_lion
  end

  head do
    url 'git://repo.or.cz/ncmpcpp.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'libmpdclient'
  depends_on 'readline'

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
    depends_on "taglib" => "c++11"
  else
    depends_on "boost"
    depends_on "taglib"
  end

  depends_on 'fftw' if build.include? "visualizer"

  option 'outputs', 'Compile with mpd outputs control'
  option 'visualizer', 'Compile with built-in visualizer'
  option 'clock', 'Compile with optional clock tab'

  needs :cxx11

  def install
    ENV.cxx11
    ENV.append 'LDFLAGS', '-liconv'
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-taglib",
            "--with-curl",
            "--enable-unicode"]
    args << '--enable-outputs' if build.include? 'outputs'
    args << '--enable-visualizer' if build.include? 'visualizer'
    args << '--enable-clock' if build.include? 'clock'

    if build.head?
      # Also runs configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make install"
  end
end
