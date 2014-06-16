require 'formula'

class OpenOcd < Formula
  homepage 'http://sourceforge.net/projects/openocd/'
  url 'https://downloads.sourceforge.net/project/openocd/openocd/0.8.0/openocd-0.8.0.tar.bz2'
  sha1 '10bf9eeb54e03083cb1a101785b2d69fbdf18f31'

  head do
    url 'git://git.code.sf.net/p/openocd/code'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  option 'with-hidapi', 'Enable building support for devices using HIDAPI (CMSIS-DAP)'
  option 'with-libftdi', 'Enable building support for libftdi-based drivers (USB-Blaster, ASIX Presto, OpenJTAG)'

  depends_on 'pkg-config' => :build
  depends_on 'libusb' => :recommended
  # some drivers are still not converted to libusb-1.0
  depends_on 'libusb-compat' if build.with? 'libusb'
  depends_on 'libftdi' => :recommended
  depends_on 'hidapi' => :recommended

  def install
    # all the libusb and hidapi-based drivers are auto-enabled when
    # the corresponding libraries are present in the system
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-dummy
      --enable-buspirate
      --enable-jtag_vpi
      --enable-remote-bitbang
    ]

    if build.with? "libftdi"
      args << "--enable-usb_blaster_libftdi"
      args << "--enable-presto_libftdi"
      args << "--enable-openjtag_ftdi"
      args << "--enable-legacy-ft2232_libftdi"
    end

    ENV['CCACHE'] = 'none'

    system "./bootstrap", "nosubmodule" if build.head?
    system "./configure", *args
    system "make install"
  end
end
