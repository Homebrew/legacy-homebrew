class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.5/QuantLib-1.5.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/q/quantlib/quantlib_1.5.orig.tar.gz"
  sha256 "bc4edcc3ace5b0668f8f75af9834fb0c04b0a0a1b79ec9338a9e5e2f1ccebd33"

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
