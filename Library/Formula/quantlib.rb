class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.7/QuantLib-1.7.tar.gz"
  mirror "https://distfiles.macports.org/QuantLib/QuantLib-1.7.tar.gz"
  sha256 "4b6f595bcac4fa319f0dc1211ab93df461a6266c70b2fc479aaccc746eb18c9b"

  head do
    url "https://github.com/lballabio/quantlib.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "a127ad7e96474ccc5ce9222809dc16f8d788f7ce0e37e016aef4c5b95b27dfb2" => :el_capitan
    sha256 "128bb13a29b675d4d918fe846b6898c16dcff7bdc68ccb7b02b9534514085d76" => :yosemite
    sha256 "6cfa46314ac7485a695b955caaf1f695143f4d992feedee46b7a35a6085dce9d" => :mavericks
    sha256 "b4a92d817a27f6d3d848d3ef51db76646ade2f372a050116859ab3f6d8be6b43" => :mountain_lion
  end

  option :cxx11

  # fix for quantlib 1.7 linking conflicts with the boost thread library
  # this patch must be removed when quantlib 1.8 is released, because quantlib maintainers fixed the bug
  # (see https://github.com/lballabio/QuantLib/commit/d1909593d9f36c6703966460fb48773792facd7e)
  patch :p0 do
    url "https://gist.githubusercontent.com/enricodetoma/7d7b137b69726815f070/raw/aa952c28854df8bf3e95069ba1beb3ec76924644/patch-FRA"
    sha256 "cd5814785b3850bfd88559e94331ac3ae907868c36bfa23dbba41e2ef87cd9d9"
  end

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
