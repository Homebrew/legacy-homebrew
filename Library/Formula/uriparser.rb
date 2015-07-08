class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
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
    sha256 "6a6ca5b4d0a1244b918c6d49240996d359fbc0373f7f2e7ead8a4ef6e88b7934" => :yosemite
    sha256 "eb5143ee0ed00da74ba1df9abe9997fd5cb523d232a2503d25403345ce0e6ee5" => :mavericks
    sha256 "bc5812a35b617cc3bd430b52d2f2a76fe3fdea0ba92522fdc5385ad8ff5d05ba" => :mountain_lion
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
