require 'formula'

class Bochs < Formula
  homepage 'http://bochs.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/bochs/bochs/2.6.2/bochs-2.6.2.tar.gz'
  sha1 'f82ee01a52367d2a6daffa2774a1297b978f6821'

  option 'with-smp', 'Enable SMP-simulation support.'

  depends_on 'pkg-config' => :build
  depends_on 'sdl' => :optional
  depends_on :x11  => :optional
  depends_on 'gtk+' if build.with? :x11

  def install
    args = %W[--prefix=#{prefix}
              --enable-debugger
              --enable-disasm
              --disable-docbook
              --enable-x86-64
              --enable-pci
              --enable-all-optimizations
              --enable-plugins
              --enable-cdrom
              --enable-a20-pin
              --enable-fpu
              --enable-alignment-check
              --enable-large-ramfile
              --enable-debugger-gui
              --enable-readline
              --enable-iodebug
              --enable-xpm
              --enable-show-ips
              --enable-logging
              --enable-usb
              --enable-ne2000
              --enable-cpu-level=6
              --enable-sb16
              --enable-clgd54xx
              --with-term
              --enable-ne2000
    ]

    args << ( build.with?( 'x11' ) ? '--with-x11'   : '--without-x11' )
    args << ( build.with?( 'x11' ) ? '--enable-debugger-gui' : '--disable-debugger-gui' )
    args << ( build.with?( 'sdl' ) ? '--with-sdl'   : '--without-sdl' )
    args << ( build.with?( 'smp' ) ? '--enable-smp' : '--disable-smp' )

    if build.without?( 'x11' ) and build.without?( 'sdl' )
      args << '--with-nogui'
    end

    system "./configure", *args

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
