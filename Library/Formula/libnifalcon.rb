require 'formula'

class Libnifalcon <Formula
  url ''
  homepage 'http://libnifalcon.nonpolynomial.com/'
  md5 ''

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'libusb'

  def install
   mkdir 'libnifalcon-build'
    Dir.chdir 'libnifalcon-build' do      
      makefiles = "cmake -G 'Unix Makefiles' -DCMAKE_INSTALL_PREFIX:PATH=#{prefix} .."
      system makefiles
      system "make"
      system "make install"
    end
  end

end
