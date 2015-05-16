require 'formula'

class Libgfshare < Formula
  homepage 'http://www.digital-scurf.org/software/libgfshare'
  url 'http://www.digital-scurf.org/files/libgfshare/libgfshare-1.0.5.tar.gz'
  sha1 '165c721e04a2aa0bd2f3b14377bca8f65603640a'

  bottle do
    cellar :any
    revision 1
    sha1 "22009f2d1a304fcc86ff49b17c19551222522294" => :yosemite
    sha1 "34f1dbaa969f1cf59f039934c7e1040e7bcdabbd" => :mavericks
    sha1 "adbd4b89054c0fc412e6a8d79a1036305ec52ace" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-linker-optimisations",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "test.in"
    system "#{bin}/gfsplit", "test.in"
    system "#{bin}/gfcombine test.in.*"
  end
end
