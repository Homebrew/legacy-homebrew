class Uriparser < Formula
  homepage "http://uriparser.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uriparser/Sources/0.8.2/uriparser-0.8.2.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/u/uriparser/uriparser_0.8.2.orig.tar.bz2"
  sha256 "6d6e66b0615f65e9e2391933dab7e45eca0947160f10c6b47bc50feda93e508f"

  head do
    url "git://git.code.sf.net/p/uriparser/git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "4aa9b66b5ff2cd4cc32e3a43759fd27d85409750" => :yosemite
    sha1 "d12b3817d93aabbac1f4afad651ecf6ee05274f8" => :mavericks
    sha1 "f8d78d458c6579be32e769a4c1d0138ccbece282" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cpptest"

  conflicts_with "libkml", :because => "both install `liburiparser.dylib`"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc"
    system "make", "check"
    system "make", "install"
  end

  test do
    expected = <<-EOS.undent
      uri:          http://brew.sh
      scheme:       http
      hostText:     brew.sh
      absolutePath: false
    EOS
    assert_equal expected, shell_output("#{bin}/uriparse http://brew.sh").chomp
  end
end
