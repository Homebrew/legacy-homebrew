require 'formula'

class Libopkele < Formula
  desc "C++ implementation of OpenID decentralized identity system"
  homepage 'http://kin.klever.net/libopkele/'

  stable do
    url "http://kin.klever.net/dist/libopkele-2.0.4.tar.bz2"
    sha1 "0c403d118efe6b4ee4830914448078c0ee967757"

    patch do
      url "https://github.com/hacker/libopkele/commit/9ff6244998b0d41e71f7cc7351403ad590e990e4.diff"
      sha1 "dd86d5a493a54f57ac3bc842878cba5c6608aa7e"
    end
  end

  bottle do
    cellar :any
    sha1 "7f83e74f921f023c804c0b6956e384289a52ac6a" => :mountain_lion
  end

  head do
    url 'https://github.com/hacker/libopkele.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-docs", "Build and install documentation"

  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build if build.with? "docs"

  def install
    system "./autogen.bash" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    if build.with? "docs"
      system "make", "dox"
      doc.install "doxydox/html"
    end
  end
end
