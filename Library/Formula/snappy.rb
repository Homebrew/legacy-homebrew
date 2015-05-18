class Snappy < Formula
  homepage "http://snappy.googlecode.com"
  url "https://drive.google.com/uc?id=0B0xs9kK-b5nMOWIxWGJhMXd6aGs&export=download"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/snappy/snappy_1.1.2.orig.tar.gz"
  sha256 "f9d8fe1c85494f62dbfa3efe8e73bc23d8dec7a254ff7fe09ec4b0ebfc586af4"
  version "1.1.2"

  head do
    url "https://github.com/google/snappy.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    revision 2
    sha256 "ee479c2aa998b56012f5c533a020bb66824388b1392b18b47394a42f45dc68bf" => :yosemite
    sha256 "f16a3840789560e902db8cc57be39fb7c57378d831d8f6a8798d78b3949d1de7" => :mavericks
    sha256 "4753cbe46233824642eb901b2b03ed205db610387b28bc7ea678ccd2bf133687" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build

  def install
    ENV.universal_binary if build.universal?
    ENV.j1 if build.stable?

    if build.head?
      # https://github.com/google/snappy/pull/4
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
