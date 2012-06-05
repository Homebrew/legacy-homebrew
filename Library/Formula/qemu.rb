require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu.org/download/qemu-1.0.1.tar.gz'
  sha1 '4d08b5a83538fcd7b222bec6f1c584da8d12497a'

  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'

  fails_with :clang do
    build 318
  end

  # Borrow these patches from MacPorts
  def patches
    { :p0 => [
      "https://trac.macports.org/export/92470/trunk/dports/emulators/qemu/files/patch-configure.diff",
      "https://trac.macports.org/export/92470/trunk/dports/emulators/qemu/files/patch-cocoa-uint16-redefined.diff"
    ]}
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--cc=#{ENV.cc}",
                          "--host-cc=#{ENV.cc}",
                          "--disable-darwin-user",
                          "--enable-cocoa",
                          "--disable-bsd-user",
                          "--disable-guest-agent"
    system "make install"
  end
end
