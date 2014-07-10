require "formula"

class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/0.6.0/libsodium-0.6.0.tar.gz"
  sha256 "84cdb6bf8ae3384f3ef78636f93bc689df748c1d36f87d4b6ab1e31c2d4dd145"
  revision 1

  bottle do
    cellar :any
    sha1 "17f16784be8dd6f3892fee1e8b765f248b395526" => :mavericks
    sha1 "34e1cb906d01591db753b44f913bff23d6f24e8c" => :mountain_lion
    sha1 "68d36857985a73fef90caf6e734b5107ba192ea8" => :lion
  end

  # Required to generate the .pc file, but can be removed at the next release
  depends_on "pkg-config" => :build

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
