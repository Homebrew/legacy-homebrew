require 'formula'

class Kbtin < Formula
  homepage 'http://kbtin.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/kbtin/kbtin/1.0.14/kbtin-1.0.14.tar.xz'
  sha1 'b6e09ee7702fe52d48db53098c79fe243505cc0f'
  revision 1

  depends_on 'gnutls'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
