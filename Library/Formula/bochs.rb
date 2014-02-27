require 'formula'

class Bochs < Formula
  homepage 'http://bochs.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/bochs/bochs/2.6.2/bochs-2.6.2.tar.gz'
  sha1 'f82ee01a52367d2a6daffa2774a1297b978f6821'

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

    # See: http://sourceforge.net/p/bochs/discussion/39592/thread/9c22887c
    inreplace 'config.h', 'define BX_HAVE_LTDL 1', 'define BX_HAVE_LTDL 0'
    inreplace 'Makefile' do |s|
      s.gsub! /\-lltdl/, 'ltdl.o'
    end

    system "make"
    system "make install"
  end

  test do
    system "#{bin}/bochs"
  end
end
