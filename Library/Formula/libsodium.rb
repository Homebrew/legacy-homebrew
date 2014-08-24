require "formula"

class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/0.7.0/libsodium-0.7.0.tar.gz"
  sha256 "4ccaffd1a15be67786e28a61b602492a97eb5bcb83455ed53c02fa038b8e9168"

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
