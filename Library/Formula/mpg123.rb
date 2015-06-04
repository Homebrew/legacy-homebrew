class Mpg123 < Formula
  homepage "http://www.mpg123.de/"
  url "http://www.mpg123.de/download/mpg123-1.22.2.tar.bz2"
  mirror "http://mpg123.orgis.org/download/mpg123-1.22.2.tar.bz2"
  sha256 "6d1e2487777114ba8a73c543f355cacfa2055646724000fc195ac9e64c843744"

  bottle do
    cellar :any
    sha1 "79906a0fc98440a39b3e858d3d4e52a308f05739" => :yosemite
    sha1 "5ce299d371755450153e411fd1cc812a1ec82dd4" => :mavericks
    sha1 "424a07fe1cb44ed42cbf6971e6722da38cc18554" => :mountain_lion
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
    system "make install"
  end
end
