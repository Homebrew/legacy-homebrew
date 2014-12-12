require "formula"

# Note that x.even are stable releases, x.odd are devel releases
class Libuv < Formula
  homepage "https://github.com/joyent/libuv"
  url "https://github.com/joyent/libuv/archive/v0.10.29.tar.gz"
  sha1 "c04d8e4bf1ccab1e13e8fa0e409b6e41b27eb6a7"

  bottle do
    cellar :any
    sha1 "9199cb57bae9e08161f3ab84b5982234d488e004" => :yosemite
    sha1 "c0965d09dd467787801fda71b310b14fcd16f29c" => :mavericks
    sha1 "071893cfe4e4a07a53d9feb8b928e8449f30485c" => :mountain_lion
  end

  head do
    url "https://github.com/joyent/libuv.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  devel do
    url "https://github.com/joyent/libuv/archive/v1.0.0-rc2.tar.gz"
    sha1 "914c74fd2a1ff92e852f37e39c3fa086e255bb3f"
    version "1.0.0-rc2"

    depends_on "pkg-config" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    if build.stable?
      system "make", "libuv.dylib"
      prefix.install "include"
      lib.install "libuv.dylib"
    else
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end
end
