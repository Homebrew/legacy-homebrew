require 'formula'

class Qemu <Formula
  url 'http://download.savannah.gnu.org/releases/qemu/qemu-0.12.3.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 'd215e4568650e8019816397174c090e1'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-darwin-user",
                          "--enable-cocoa",
                          "--disable-bsd-user"
    system "make install"
  end
end
