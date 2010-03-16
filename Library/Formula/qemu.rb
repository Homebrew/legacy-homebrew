require 'formula'

class Qemu <Formula
  url 'http://download.savannah.gnu.org/releases/qemu/qemu-0.12.2.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 '1d7c2d95acb6d0789de86508c608e26d'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-darwin-user",
                          "--enable-cocoa",
                          "--disable-bsd-user"
    system "make install"
  end
end
