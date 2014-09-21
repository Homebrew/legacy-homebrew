require "formula"

class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/0.7.1/libsodium-0.7.1.tar.gz"
  sha256 "ef46bbb5bac263ef6d3fc00ccc11d4690aea83643412919fe15369b9870280a7"

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
