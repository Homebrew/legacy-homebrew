class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.6/QuantLib-1.6.tar.gz"
  mirror "https://distfiles.macports.org/QuantLib/QuantLib-1.6.tar.gz"
  sha256 "a135d424a59cbb00a75d7f7ac3a181d49e804abae1776b555ec0183e309f81ce"

  head do
    url "https://github.com/lballabio/quantlib.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "c5055d99ba3863d104bfadd91c70eb2034f047c4c143123a279bddc98408ca16" => :yosemite
    sha256 "0615b7ac6295b12ff38cfe19cfc0e249fd7b24d1842d9a20432763bf60154c2e" => :mavericks
    sha256 "018a317da05e97d1764af2d849c416ca0977ed52f526ff9204d85f71bd990e04" => :mountain_lion
  end

  option :cxx11

  if build.cxx11?
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if build.cxx11?
    if build.head?
      Dir.chdir "QuantLib"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
