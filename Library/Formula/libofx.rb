require 'formula'

class Libofx < Formula
  homepage 'http://libofx.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/libofx/libofx/0.9.9/libofx-0.9.9.tar.gz'
  sha1 'b8ea875cee16953166449de8ddd1b69fb181f61b'

  depends_on 'open-sp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
