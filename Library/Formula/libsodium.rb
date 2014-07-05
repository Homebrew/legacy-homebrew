require "formula"

class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/0.6.0/libsodium-0.6.0.tar.gz"
  sha256 "84cdb6bf8ae3384f3ef78636f93bc689df748c1d36f87d4b6ab1e31c2d4dd145"
  revision 1

  bottle do
    cellar :any
    sha1 "080e59842caf764b7ecea97c9d833a86bb1151de" => :mavericks
    sha1 "22fba7782863fe55c1b64c6704757ef7f32c2a07" => :mountain_lion
    sha1 "40fcd281e55c4b0925f99f602a95dfc0b6afb6e0" => :lion
  end

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
