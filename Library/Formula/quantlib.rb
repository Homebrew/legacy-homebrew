class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.6.1/QuantLib-1.6.1.tar.gz"
  mirror "https://distfiles.macports.org/QuantLib/QuantLib-1.6.1.tar.gz"
  sha256 "4f90994671173ef20d2bfd34cefc79f753370d79eccafaec926db8c4b6c37870"

  head do
    url "https://github.com/lballabio/quantlib.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "128bb13a29b675d4d918fe846b6898c16dcff7bdc68ccb7b02b9534514085d76" => :yosemite
    sha256 "6cfa46314ac7485a695b955caaf1f695143f4d992feedee46b7a35a6085dce9d" => :mavericks
    sha256 "b4a92d817a27f6d3d848d3ef51db76646ade2f372a050116859ab3f6d8be6b43" => :mountain_lion
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
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{share}/emacs/site-lisp/quantlib"
    system "make", "install"
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
