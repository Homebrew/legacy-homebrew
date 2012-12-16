require 'formula'

class DmtxUtils < Formula
  homepage ''
  url 'http://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.4/dmtx-utils-0.7.4.tar.bz2'
  homepage 'http://www.libdmtx.org'
  version '0.7.4'
  sha1 'e56990bf058c109206124f8d9177715b7675e657'

  depends_on 'libdmtx'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "[ \"My Test\" = \"`echo 'My Test' | dmtxwrite | dmtxread`\" ]"
  end
end
