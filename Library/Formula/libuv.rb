require "formula"

# Note that x.even are stable releases, x.odd are devel releases
class Libuv < Formula
  homepage "https://github.com/joyent/libuv"
  url "https://github.com/joyent/libuv/archive/v0.10.21.tar.gz"
  sha1 "883bb240d84e1db11b22b5b0dfdd117ed6bc6318"

  bottle do
    cellar :any
    revision 1
    sha1 "a897f491618c4c14f35e87d92765ae92c61ccfa2" => :yosemite
    sha1 "bac4d19684a5108459fed73fcb459f0d12f60213" => :mavericks
  end

  head do
    url "https://github.com/joyent/libuv.git", :branch => "master"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  devel do
    url "https://github.com/joyent/libuv/archive/v1.0.0-rc1.tar.gz"
    sha1 "5be6817b15980b0453b3da3dafb4beea16e90d8f"
    version "1.0.0-rc1"

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
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end
end
