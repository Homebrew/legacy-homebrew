require 'formula'

class Libofx < Formula
  homepage 'http://libofx.sourceforge.net'
  url 'http://sourceforge.net/projects/libofx/files/libofx/0.9.5/libofx-0.9.5.tar.gz'
  sha1 '7e5245d68a0f3f7efad2fd809b2afbbff6ba0e73'

  depends_on 'open-sp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
