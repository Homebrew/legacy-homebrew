require "formula"

class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/0.6.1/libsodium-0.6.1.tar.gz"
  sha256 "04ccfeebd23659f3a1f73a828d1b88b984f9c984176f388daf77fe3968cc3694"

  bottle do
    cellar :any
    sha1 "17f16784be8dd6f3892fee1e8b765f248b395526" => :mavericks
    sha1 "34e1cb906d01591db753b44f913bff23d6f24e8c" => :mountain_lion
    sha1 "68d36857985a73fef90caf6e734b5107ba192ea8" => :lion
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
