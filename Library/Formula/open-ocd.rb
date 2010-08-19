require 'formula'

class OpenOcd <Formula
  url 'http://download.berlios.de/openocd/openocd-0.4.0.tar.bz2'
  homepage 'http://openocd.berlios.de/web/'
  md5 '11a81b5f200fb0c318d9f49182bb71d7'

  depends_on 'libusb-compat'
  depends_on 'libftdi' if ARGV.include? "--enable-ft2232_libftdi"

  def options
    [["--enable-ft2232_libftdi", "Compile against libftdi."]]
  end

  def install
    args = ["--enable-maintainer-mode", "--prefix=#{prefix}"]
    args << "--enable-ft2232_libftdi" if ARGV.include? "--enable-ft2232_libftdi"

    system "./configure", *args
    system "make install"
  end
end
