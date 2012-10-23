require 'formula'

class OpenOcd < Formula
  url 'http://downloads.sourceforge.net/project/openocd/openocd/0.6.1/openocd-0.6.1.tar.bz2'
  homepage 'http://sourceforge.net/projects/openocd/'
  sha1 'b286dd9c0c6ca5cc7a76d25e404ad99a488e2c61'

  depends_on 'libusb-compat'

  if ARGV.include?('--enable-ft2232_libftdi')
    depends_on 'libftdi'
  end

  def options
    [
      ['--enable-ft2232_libftdi', 'Enable building support for FT2232 based devices with libftdi driver'  ],
      ['--enable-ft2232_ftd2xx',  'Enable building support for FT2232 based devices with FTD2XX driver'   ]
    ]
  end

  def install
    args = [
      # default options that don't imply additional dependencies
      "--enable-ftdi",
      "--enable-arm-jtag-ew",
      "--enable-jlink",
      "--enable-rlink",
      "--enable-stlink",
      "--enable-ulink",
      "--enable-usbprog",
      "--enable-vsllink",
      "--enable-ep93xx",
      "--enable-at91rm9200",
      "--enable-ecosboard",
      "--enable-opendous",
      "--enable-osbdm",
      "--enable-buspirate"
    ]

    # additional opt-in options
    if ARGV.include? "--enable-ft2232_libftdi"
      args << "--enable-ft2232_libftdi"
      args << "--enable-presto_libftdi"
      args << "--enable-usb_blaster_libftdi"
    end

    if ARGV.include? "--enable-ft2232_ftd2xx"
      args << "--enable-ft2232_ftd2xx"
      args << "--enable-presto_ftd2xx"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", *args
    system "make install"
  end
end
