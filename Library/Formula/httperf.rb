class Httperf < Formula
  desc "Tool for measuring webserver performance"
  homepage "https://code.google.com/p/httperf/"
  url "https://httperf.googlecode.com/files/httperf-0.9.0.tar.gz"
  sha256 "e1a0bf56bcb746c04674c47b6cfa531fad24e45e9c6de02aea0d1c5f85a2bf1c"
  revision 1

  bottle do
    cellar :any
    sha256 "42d9ecb49274565dd969ceb5c2c9135caf1011a2f1636f22401a30189298613a" => :el_capitan
    sha256 "d23d569b210c93d798f319e01ddeb9cca1dd11e5c5330a0df0eef59497dbb12d" => :yosemite
    sha256 "e6a03dce9f3679d23449b9fed857324d570b8fb6b94a3d31b5e172253eaa99dd" => :mavericks
    sha256 "e52a0a55a440ba301d8ca469a5a1ef3d6ec5e51fa8df0662674d25f3c9c96b77" => :mountain_lion
  end

  # Upstream actually recommend using head over stable now.
  head do
    url "https://httperf.googlecode.com/svn/trunk/"

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
