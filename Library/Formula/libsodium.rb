require "formula"

class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/0.7.0/libsodium-0.7.0.tar.gz"
  sha256 "4ccaffd1a15be67786e28a61b602492a97eb5bcb83455ed53c02fa038b8e9168"

  bottle do
    cellar :any
    sha1 "ca839a670db890368991ed87aa5b3d67411ba9d6" => :mavericks
    sha1 "a79059314bfdee0c91b1899e73e5135a70bde753" => :mountain_lion
    sha1 "1bb615898bd7751553069c76e9ddd901b568ef9b" => :lion
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
