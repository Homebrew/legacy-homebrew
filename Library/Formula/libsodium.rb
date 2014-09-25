require "formula"

class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.0/libsodium-1.0.0.tar.gz"
  sha256 "ced1fe3d2066953fea94f307a92f8ae41bf0643739a44309cbe43aa881dbc9a5"

  bottle do
    cellar :any
    sha1 "ebe8db5c6f99bfa295c2b7ee591f6c3f77de6aa2" => :mavericks
    sha1 "1b068574f2c6fd56b35a2e7d30011d697a25d927" => :mountain_lion
    sha1 "fd07ccba946fa7d7fbe287c94990a773041db5ff" => :lion
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
