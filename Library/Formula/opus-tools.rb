class OpusTools < Formula
  desc "Utilities to encode, inspect, and decode .opus files"
  homepage "http://www.opus-codec.org"
  url "http://downloads.xiph.org/releases/opus/opus-tools-0.1.9.tar.gz"
  sha256 "b1873dd78c7fbc98cf65d6e10cfddb5c2c03b3af93f922139a2104baedb4643a"

  head do
    url "https://git.xiph.org/opus-tools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "opus"
  depends_on "flac"
  depends_on "libogg"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
