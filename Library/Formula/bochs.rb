require 'formula'

class Bochs < Formula
  homepage 'http://bochs.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/bochs/bochs/2.6.1/bochs-2.6.1.tar.gz'
  sha1 'fa272a69477b1d8641c387e9198eaa8ed966d6ee'

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'gtk+'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-x11",
                          "--enable-debugger",
                          "--enable-disasm",
                          "--disable-docbook",
                          "--enable-x86-64",
                          "--enable-pci",
                          "--enable-all-optimizations",
                          "--enable-plugins",
                          "--enable-cdrom",
                          "--enable-a20-pin",
                          "--enable-fpu",
                          "--enable-alignment-check",
                          "--enable-large-ramfile",
                          "--enable-debugger-gui",
                          "--enable-readline",
                          "--enable-iodebug",
                          "--enable-xpm",
                          "--enable-show-ips",
                          "--enable-logging",
                          "--enable-usb",
                          "--enable-ne2000",
                          "--enable-cpu-level=6",
                          "--enable-sb16",
                          "--enable-clgd54xx",
                          "--with-term",
                          "--enable-ne2000"

    system "make"
    system "make install"
  end

  def test
    system "#{bin}/bochs"
  end
end
