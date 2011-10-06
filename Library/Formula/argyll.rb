require 'formula'

def libusb1_install_prefix
  prefix + 'libusb1'
end

class Argyll < Formula
  version "1.3.4"
  url 'http://www.argyllcms.com/Argyll_V1.3.4_osx10.4_i86_bin.tgz', :using => CurlDownloadStrategy
  homepage 'http://www.argyllcms.com/'
  md5 '2b1f20fa3371db5c12a28b54a7e57903'
  
  def install
    prefix.install Dir['*']
    system "chmod +x #{libusb1_install_prefix}/install_kext.sh"
  end
  
  def caveats
    <<-EOS.undent
      To use ArgyllCMS for calibrating and testing USB scanners,
      the libusb1 kext must be loaded.
      
      Run the included install script manually:
      
        cd #{libusb1_install_prefix}
        ./install_kext.sh
      
      A reboot is required after installing libusb1.
    EOS
  end
  
  
end
