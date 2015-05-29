class SimpleMtpfs < Formula
  desc "Simple MTP fuse filesystem driver"
  homepage "https://github.com/phatina/simple-mtpfs"
  url "https://github.com/phatina/simple-mtpfs/archive/simple-mtpfs-0.2.tar.gz"
  sha256 "3ce41fb194971041aa6ad15292a6cdad70eb8b5fc3e7a03a638bc3cac0c515ea"

  bottle do
    cellar :any
    sha256 "9dbbd8411c7803abaafe8ad7100074c8e1541f729ac8ef7a0a239ad55dd5e78b" => :mavericks
    sha256 "17ec5b77e7227cb6d0d474fc05e3ebcc90da5b6d791053d81710abb07e6f8376" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :osxfuse
  depends_on "libmtp"
  needs :cxx11

  def install
    ENV.cxx11
    system "./autogen.sh"
    system "./configure",
      "--prefix=#{prefix}",
      "CPPFLAGS=-I/usr/local/include/osxfuse",
      "LDFLAGS=-L/usr/local/include/osxfuse"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"simple-mtpfs", "-h"
  end
end
