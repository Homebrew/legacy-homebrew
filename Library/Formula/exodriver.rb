require 'formula'

class Exodriver <Formula
  url 'https://github.com/labjack/exodriver/tarball/31a215eafad039f5cad53007006a6d4573ea483d'
  homepage 'http://labjack.com/support/linux-and-mac-os-x-drivers'
  md5 '0a19f884fd66022154704874891cb765'
  version '2.0.4'

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

    ENV.universal_binary if ARGV.include? "--universal"
    system "make"
    system "make install"
  end
end