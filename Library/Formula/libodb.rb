require 'formula'

class Libodb < Formula
  homepage 'http://www.codesynthesis.com/products/odb/'
  url 'http://www.codesynthesis.com/download/odb/2.2/libodb-2.2.2.tar.gz'
  sha1 'f53bcbaac2d2fd4eb305eaedff7da4045cd648fe'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "false"
  end
end
