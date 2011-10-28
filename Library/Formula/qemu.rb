require 'formula'

class Qemu < Formula
  url 'http://wiki.qemu.org/download/qemu-0.15.0.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 'dbc55b014bcd21b98e347f6a90f7fb6d'

  depends_on 'jpeg'
  depends_on 'gnutls'

  fails_with_llvm "Segmentation faults occur at run-time with LLVM"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-darwin-user",
                          "--enable-cocoa",
                          "--disable-bsd-user",
                          "--disable-guest-agent"
    system "make install"
  end
end
