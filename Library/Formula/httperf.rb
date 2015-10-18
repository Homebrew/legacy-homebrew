class Httperf < Formula
  desc "Tool for measuring webserver performance"
  homepage "https://code.google.com/p/httperf/"
  url "https://httperf.googlecode.com/files/httperf-0.9.0.tar.gz"
  sha256 "e1a0bf56bcb746c04674c47b6cfa531fad24e45e9c6de02aea0d1c5f85a2bf1c"
  revision 1

  bottle do
    cellar :any
    sha256 "42d9ecb49274565dd969ceb5c2c9135caf1011a2f1636f22401a30189298613a" => :el_capitan
    sha1 "b37decb63bdb77a6d04cb770a2d40745d2b5ee78" => :yosemite
    sha1 "5e00255e74995f0bfa601152329d66be8a0d7fdf" => :mavericks
    sha1 "cc699648d2c48f2a9a8fa94da42831c3551e8475" => :mountain_lion
  end

  # Upstream actually recommend using head over stable now.
  head do
    url "http://httperf.googlecode.com/svn/trunk/"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "enable-debug" => "with-debug"

  option "with-debug", "Build with debugging support"

  depends_on "openssl"

  def install
    args = ["--prefix=#{prefix}",
            "--disable-dependency-tracking"]

    args << "--enable-debug" if build.with? "debug"

    if build.head?
      cd "httperf"
      # Shipped permissions = Access to configure.ac denied.
      # Probably no chance of this being fixed upstream.
      chmod 0755, "configure.ac"
      system "autoreconf", "-i"
    end
    system "./configure", *args
    system "make", "install"
  end
end
