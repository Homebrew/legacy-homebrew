class Quantlib < Formula
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
    revision 1
    sha1 "05127a732538048ea590627c768c83c9034ccf5d" => :yosemite
    sha1 "eff03577fd90569d8541d64161d9e08851d71ba8" => :mavericks
    sha1 "19d71ade61f7f55518dfed37ffa46114357b2056" => :mountain_lion
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
