require "formula"

class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.0/libsodium-1.0.0.tar.gz"
  sha256 "ced1fe3d2066953fea94f307a92f8ae41bf0643739a44309cbe43aa881dbc9a5"

  bottle do
    cellar :any
    sha1 "212b7e48a175332fc1d79ecc4b64d1e1d23c03e3" => :mavericks
    sha1 "ab999ec2d752494ea99ef94f224a69c83257aa4a" => :mountain_lion
    sha1 "ae9a37f6b0e3bbb482cfdccafc8c66a91e5db330" => :lion
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
