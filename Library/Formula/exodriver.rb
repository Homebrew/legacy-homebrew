require 'formula'

class Exodriver < Formula
  url 'https://github.com/labjack/exodriver/tarball/v2.0.4'
  homepage 'http://labjack.com/support/linux-and-mac-os-x-drivers'
  md5 '9208085ee8a9166898dc812b9d7e1905'

  head 'https://github.com/labjack/exodriver.git', :using => :git

  depends_on 'libusb'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    cd 'liblabjackusb'
    mv 'Makefile.MacOSX', 'Makefile'

    inreplace 'Makefile' do |s|
      s.change_make_var! 'DESTINATION', lib
      s.change_make_var! 'HEADER_DESTINATION', include
    end

    ENV.universal_binary if ARGV.build_universal?
    system "make"
    system "make install"
  end
end
