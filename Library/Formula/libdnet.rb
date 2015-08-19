class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://code.google.com/p/libdnet/"
  url "https://libdnet.googlecode.com/files/libdnet-1.12.tgz"
  sha256 "83b33039787cf99990e977cef7f18a5d5e7aaffc4505548a83d31bd3515eb026"

  bottle do
    cellar :any
    revision 2
    sha256 "09996ef2a4fce855bd5302996000f5ab49fd28d3e6bf6f0d82d3f11d495baef1" => :yosemite
    sha256 "1b425f04354f60b2c9de0b6e031d50f626d3cda0dc50c892b163107a6eecacb9" => :mavericks
    sha256 "c8fda878e8ff2a87a3b521ca26a5ebb0d4b9eb82868a92149c723c4bf21f5b79" => :mountain_lion
  end

  option "without-python", "Build without python support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "-ivf"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]
    args << "--with-python" if build.with? "python"
    system "./configure", *args
    system "make", "install"
  end
end
