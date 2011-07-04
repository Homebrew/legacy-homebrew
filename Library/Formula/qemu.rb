require 'formula'

class Qemu < Formula
  url 'http://download.savannah.gnu.org/releases/qemu/qemu-0.14.1.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 'b6c713a8db638e173af53a62d5178640'

  depends_on 'jpeg'
  depends_on 'gnutls'

  fails_with_llvm "Segmentation faults occur at run-time with LLVM"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-darwin-user",
                          "--enable-cocoa",
                          "--disable-bsd-user"
    system "make install"
  end
end
