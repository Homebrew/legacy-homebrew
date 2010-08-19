require 'formula'

class Qemu <Formula
  url 'http://download.savannah.gnu.org/releases/qemu/qemu-0.12.5.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 '1d02ee0a04dfae2894340273372c1de4'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-darwin-user",
                          "--enable-cocoa",
                          "--disable-bsd-user"
    system "make install"
  end
end
