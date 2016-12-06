require 'formula'

class Libomron <Formula
  url 'http://downloads.sourceforge.net/project/nplabs/libomron/0.9.0/libomron-0.9.0.tar.gz'
  homepage 'http://libomron.nonpolynomial.com/'
  md5 '8def0f7fa82318a44b09a1acbd6caf84'

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
  end

end
