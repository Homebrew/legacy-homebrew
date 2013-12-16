require 'formula'

class Libgfshare < Formula
  homepage 'http://www.digital-scurf.org/software/libgfshare'
  url 'http://www.digital-scurf.org/files/libgfshare/libgfshare-1.0.5.tar.gz'
  sha1 '165c721e04a2aa0bd2f3b14377bca8f65603640a'

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
