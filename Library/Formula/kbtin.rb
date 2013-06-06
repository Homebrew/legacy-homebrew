require 'formula'

class Kbtin < Formula
  homepage 'http://kbtin.sourceforge.net'
  url 'http://sourceforge.net/projects/kbtin/files/kbtin/1.0.14/kbtin-1.0.14.tar.xz'
  sha1 'b6e09ee7702fe52d48db53098c79fe243505cc0f'

  depends_on 'xz' => :build
  depends_on 'gnutls'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
