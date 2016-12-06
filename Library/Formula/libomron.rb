require 'formula'

class Libomron <Formula
  url 'http://downloads.sourceforge.net/project/nplabs/libomron/0.9.0/libomron-0.9.0.tar.gz'
  homepage 'http://libomron.nonpolynomial.com/'
  md5 '8def0f7fa82318a44b09a1acbd6caf84'
  head 'git://github.com/qdot/libomron.git'

  depends_on 'cmake' => :build
  depends_on 'libusb'

  def install
    mkdir 'libomron-build'
    Dir.chdir 'libomron-build' do
      makefiles = "cmake -G 'Unix Makefiles' -DCMAKE_INSTALL_PREFIX:PATH=#{prefix} .."
      system makefiles
      system "make"
      system "make install"
    end
    prefix.install Dir['platform/osx/OmronNullDriver.kext']
  end

  def caveats
    s = <<-EOS.undent
        libomron will not work unless you copy the OmronNullDriver.kext to /System/Library/Extensions

        Please run the following command:

        sudo cp -r #{prefix}/OmronNullDriver.kext /System/Library/Extensions

        After this, you can either reboot, or run the following command:

        sudo kextload /System/Library/Extensions/OmronNullDriver.kext

        If you have a device currently plugged in, after running the above command, you will need to unplug and replug it in order for libomron software to work.
    EOS
    return s
  end
end
