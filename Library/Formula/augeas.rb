class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.4.0.tar.gz"
  sha256 "659fae7ac229029e60a869a3b88c616cfd51cf2fba286cdfe3af3a052cb35b30"

  bottle do
    revision 1
    sha256 "34d6940f0ab935135c1a69a31c878712c9b28954e6686f52f48315c6e7c92f3e" => :el_capitan
    sha256 "0cc6f1fe0eff9493bc33044c3a8289120bcd2ffaebf2a3623bf95ae9b7baf7a9" => :yosemite
    sha256 "fd49d49a8dce0fd653b21536c2396a8ecd9f394c73ea4ec6cd50d90eb39303d0" => :mavericks
  end

  head do
    url "https://github.com/hercules-team/augeas.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "readline"

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Lenses have been installed to:
      #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end
