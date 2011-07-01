require 'formula'

class Qemu < Formula
  url 'http://download.savannah.gnu.org/releases/qemu/qemu-0.14.0.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 'f9d145d5c09de9f0984ffe9bd1229970'

  depends_on 'jpeg'
  depends_on 'gnutls'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-darwin-user",
                          "--enable-cocoa",
                          "--disable-bsd-user"
    system "make install"
  end
end
