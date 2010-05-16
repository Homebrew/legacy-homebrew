require 'formula'

class Qemu <Formula
  url 'http://download.savannah.gnu.org/releases/qemu/qemu-0.12.4.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 '93e6b134dff89b2799f57b7d9e0e0fc5'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-darwin-user",
                          "--enable-cocoa",
                          "--disable-bsd-user"
    system "make install"
  end
end
