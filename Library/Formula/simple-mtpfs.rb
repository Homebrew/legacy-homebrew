class SimpleMtpfs < Formula
  desc "Simple MTP fuse filesystem driver"
  homepage "https://github.com/phatina/simple-mtpfs"
  url "https://github.com/phatina/simple-mtpfs/archive/simple-mtpfs-0.2.tar.gz"
  sha256 "3ce41fb194971041aa6ad15292a6cdad70eb8b5fc3e7a03a638bc3cac0c515ea"

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
