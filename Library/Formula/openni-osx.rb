require 'formula'

class OpenniOsx < Formula
  url 'https://github.com/OpenNI/OpenNI/zipball/Stable-1.5.2.23'
  homepage 'https://github.com/OpenNI/OpenNI'
  md5 '74f1a05b41ee099df3c461baaeecb7da'

  depends_on "libusb-devel"

  def install
#    Dir.chdir 'Platform/Linux/CreateRedist' do
#      system "./RedistMaker"
#      Dir.chdir '../Redist' do
#        system "./install.sh"
#      end
#    end
    Dir.chdir 'Platform/Linux/Build' do
      system "make install"
    end
  end
end
