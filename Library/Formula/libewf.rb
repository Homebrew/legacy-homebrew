require 'formula'

class Libewf < Formula
  homepage 'http://sourceforge.net/projects/libewf/'
  url 'http://downloads.sourceforge.net/project/libewf/libewf2/libewf-20120504/libewf-20120504.tar.gz'
  sha1 'ec1231d2c7c410a2e333eaf75213fe5f6da8d685'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
