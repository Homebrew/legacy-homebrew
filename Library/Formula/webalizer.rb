require 'formula'

class Webalizer < Formula
  homepage "http://www.mrunix.net/webalizer/"
  url "ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.23-05-src.tgz"
  mirror "http://tweedo.com/mirror/webalizer/webalizer-2.23-05-src.tgz"
  sha1 "bc28ff28d9484c8e9793ec081c7cbfcb1f577351"
  bottle do
    sha1 "4eebb723a0516001a63c0546a2e1c1561df07ad6" => :mavericks
    sha1 "1a6a9fa2987ad8802c90b721998f290b7e11cfc0" => :mountain_lion
    sha1 "308877c08ac3f82def55bd00f65772cc3c0c8805" => :lion
  end

  revision 1

  depends_on 'gd'
  depends_on 'berkeley-db'
  depends_on 'libpng'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
