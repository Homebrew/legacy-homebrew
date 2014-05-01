require 'formula'

class OpenOcd < Formula
  homepage 'http://sourceforge.net/projects/openocd/'
  url 'https://downloads.sourceforge.net/project/openocd/openocd/0.8.0/openocd-0.8.0.tar.bz2'
  sha1 '10bf9eeb54e03083cb1a101785b2d69fbdf18f31'

  head do
    url 'git://git.code.sf.net/p/openocd/code'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end


  option 'enable-cmsis-dap', 'Enable building support for devices using CMSIS-DAP'
  option 'enable-ft2232_libftdi', 'Enable building support for FT2232 based devices with libftdi driver'
  option 'enable-ft2232_ftd2xx',  'Enable building support for FT2232 based devices with FTD2XX driver'

  depends_on 'pkg-config' => :build
  depends_on 'libusb-compat'
  depends_on 'libftdi0' if build.include? 'enable-ft2232_libftdi'
  depends_on 'hidapi' if build.include? 'enable-cmsis-dap'

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ftdi
      --enable-arm-jtag-ew
      --enable-jlink
      --enable-rlink
      --enable-stlink
      --enable-ulink
      --enable-usbprog
      --enable-vsllink
      --enable-ep93xx
      --enable-at91rm9200
      --enable-ecosboard
      --enable-opendous
      --enable-osbdm
      --enable-buspirate
    ]

    if build.include? "enable-ft2232_libftdi"
      args << "--enable-ft2232_libftdi"
      args << "--enable-presto_libftdi"
      args << "--enable-usb_blaster_libftdi"
    end

    if build.include? "enable-ft2232_ftd2xx"
      args << "--enable-ft2232_ftd2xx"
      args << "--enable-presto_ftd2xx"
    end

    if build.include? "enable-cmsis-dap"
      args << "--enable-cmsis-dap"
    end

    ENV['CCACHE'] = 'none'

    system "./bootstrap", "nosubmodule" if build.head?
    system "./configure", *args
    system "make install"
  end
end
