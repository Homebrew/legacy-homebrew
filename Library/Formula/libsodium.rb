require "formula"

class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/0.6.1/libsodium-0.6.1.tar.gz"
  sha256 "04ccfeebd23659f3a1f73a828d1b88b984f9c984176f388daf77fe3968cc3694"

  bottle do
    cellar :any
    sha1 "f59cd52a8ce5489eb989f1cbfc2dd56227edd93c" => :mavericks
    sha1 "56dbbe1b78ee2dc9f15ed69b04f59bfa572debc0" => :mountain_lion
    sha1 "e4ac5b9a58b5cb236d907541729bfcfa567f44e1" => :lion
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
