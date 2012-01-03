require 'formula'

class Qemu < Formula
  url 'http://wiki.qemu.org/download/qemu-1.0.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 'a64b36067a191451323b0d34ebb44954'

  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'
 
  fails_with_llvm "Segmentation faults occur at run-time with LLVM"

  def patches
    "https://raw.github.com/gist/1556648/softfloat-Avoid-uint16-type-conflict-on-Darwin"
  end
  
  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-cocoa",
                          "--disable-darwin-user",
                          "--enable-cocoa",
                          "--disable-bsd-user",
                          "--disable-guest-agent"
    system "make install"
  end
end
