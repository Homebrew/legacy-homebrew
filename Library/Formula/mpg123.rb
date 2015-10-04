class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "http://www.mpg123.de/"
  url "http://www.mpg123.de/download/mpg123-1.22.4.tar.bz2"
  mirror "http://mpg123.orgis.org/download/mpg123-1.22.4.tar.bz2"
  sha256 "5069e02e50138600f10cc5f7674e44e9bf6f1930af81d0e1d2f869b3c0ee40d2"

  bottle do
    cellar :any
    sha256 "fde166e822887d210c1c1883bff6fbbb7f11f27c7cabdc6895793fc8425b7e0a" => :el_capitan
    sha256 "ed08fe7657e9aad578aecb5f62d91af470381abb954cfd33c9365bf270762716" => :yosemite
    sha256 "9cf6b11c748668a8c4a1dcc9e8fd8d3ad708be36772b44e63f085252af83a46b" => :mavericks
    sha256 "cde99ad491a80565604a0879c3b78d12aabead01b437b09346a6a939e60aba29" => :mountain_lion
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-default-audio=coreaudio",
            "--with-module-suffix=.so"]

    if MacOS.prefer_64_bit?
      args << "--with-cpu=x86-64"
    else
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mpg123", test_fixtures("test.mp3")
  end
end
