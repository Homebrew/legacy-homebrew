require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu.org/download/qemu-1.1.0.tar.bz2'
  sha256 '927f498eff8dce2334de9338cae9e3a7c63bd472c85451235c45de5029140fc0'

  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'

  fails_with :clang do
    build 318
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--cc=#{ENV.cc}",
                          "--host-cc=#{ENV.cc}",
                          "--enable-cocoa",
                          "--disable-bsd-user",
                          "--disable-guest-agent"
    system "make install"
  end
end
