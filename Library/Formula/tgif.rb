class Tgif < Formula
  desc "Xlib-based interactive 2D drawing tool"
  homepage "http://bourbon.usc.edu/tgif/"
  url "https://downloads.sourceforge.net/projects/tgif/files/tgif/4.2.5/tgif-QPL-4.2.5.tar.gz"
  md5 "a622240ce2377f15b6d8261e4c49b8f6"
  sha1 "d25c8aaa7ddbeba4e720dc369d62f14b850065bc"

  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
