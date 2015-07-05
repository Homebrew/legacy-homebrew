class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.6/QuantLib-1.6.tar.gz"
  sha256 "a135d424a59cbb00a75d7f7ac3a181d49e804abae1776b555ec0183e309f81ce"

  head do
    url "https://github.com/lballabio/quantlib.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "d5e777622b83b3392f99a193346d73d85e4c595148bba4fe259ae70231bbc42f" => :yosemite
    sha256 "57615e8a88585ce4ad3e8b42c56abeced2f639fd26861201af87d322a6e10496" => :mavericks
    sha256 "6b5fbe9f581df20dbe7209ed80a51cb8cd9d8e6eabb621e52e1b5d84f04253e1" => :mountain_lion
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
