class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz"
  sha256 "e19ee34711d7af328cb26287f4137e70630e7261b17cbe3cd41011d73a654692"

  bottle do
    cellar :any
    sha256 "dde4684a0247e6b6b27025ff66a35035a9c58492516b6d5c227e8be1eb880685" => :el_capitan
    sha1 "103ee41d6c42015473a4d13b010c33d5dca29f64" => :yosemite
    sha1 "7fcbece23ab93ac6d107625aae32e966615661d1" => :mavericks
    sha1 "ba0b0f47f7043e711eb8ab3719623d15395440ab" => :mountain_lion
    sha1 "e5f0cb6f5b1546e8073cdaa9b09b65b8b7c0d696" => :lion
  end

  head do
    url "https://svn.xiph.org/trunk/ogg"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end
