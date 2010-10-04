require 'formula'

class Exodriver <Formula
  url  'http://github.com/labjack/exodriver/tarball/98cf1f83ff65ab7a317f4310d46081a476ae939c'
  homepage 'http://labjack.com/support/linux-and-mac-os-x-drivers'
  md5 'ec227347ccaf0772d175d3a2cf557105'
  version '2.0-0-98cf1f8'

  head 'http://github.com/labjack/exodriver.git', :using => :git

  depends_on 'libusb'

  def install
    cd 'liblabjackusb'
    mv 'Makefile.MacOSX', 'Makefile'

    inreplace 'Makefile' do |s|
      s.change_make_var! 'DESTINATION', lib
      s.change_make_var! 'HEADER_DESTINATION', include
    end

    system "make"
    system "make install"
  end
end