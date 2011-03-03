require 'formula'

class Qemu <Formula
  url 'http://download.savannah.gnu.org/releases/qemu/qemu-0.13.0.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 '397a0d665da8ba9d3b9583629f3d6421'

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
